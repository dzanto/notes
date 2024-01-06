---
title: "Terraform провайдер для Proxmox"
date: 2023-07-09T09:14:00+03:00
draft: false
tags: [proxmox, terraform]
---
# Terraform провайдер для Proxmox

provider.tf
```js
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_parallel       = 1
  pm_tls_insecure   = true
  pm_api_url        = var.pm_api_url
  pm_password       = var.pm_password
  pm_user           = var.pm_user
}

```

provider.tf
```js
variable "pm_api_url" {
  default = "https://192.168.1.201:8006/api2/json"
}

variable "pm_user" {
default = "root@pam"
}

variable "pm_password" {
default = "my_password"
}

variable "ssh_key" {
  default = "ssh-rsa AAyc2EAAAGsxc= dzanto@dzanto"
}
```

https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/resources/vm_qemu.md

main.tf
```js
resource "proxmox_vm_qemu" "node_1" {
  name              = "node-1"
  target_node       = "proxmox"
  clone             = "OL8U8TPL"
  oncreate          = true
  cores             = 2
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  qemu_os           = "other"

  disk {
    size            = "37G"
    type            = "scsi"
    storage         = "local-lvm"
  }

  network {
    model           = "virtio"
    bridge          = "vmbr0"
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.1.3/24,gw=192.168.1.1"
  ciuser    = "dzanto"
  sshkeys   = <<EOF
  ${var.ssh_key}
  EOF
}

```