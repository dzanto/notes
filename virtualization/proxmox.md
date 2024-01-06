---
title: "Запуск cloud-init Oracle Linux в Proxmox"
date: 2023-07-07T09:14:00+03:00
draft: false
tags: [proxmox]
---
Инструкция подготовлена на основе документации Proxmox: https://pve.proxmox.com/wiki/Cloud-Init_Support

Страница загрузки официальных образов Oracle Linux cloud image: https://yum.oracle.com/oracle-linux-templates.html, там же можно найти образы ISO, Vagrant и docker контейнеры.

Подключаемся к хосту Proxmox по ssh и скачиваем образ в формате qcow на хост Proxmox:

```sh
wget https://yum.oracle.com/templates/OracleLinux/OL9/u2/x86_64/OL9U2_x86_64-kvm-b197.qcow
```

Необходимо изменить расширение у образа .qcow на .qcow2 иначе при монтировании образа будет ошибка:

> qemu-img: Could not open '/tmp/OL8U7_x86_64-kvm-b148.qcow': qcow (v1) does not support qcow version 3 Try the 'qcow2' driver instead.

Создаем ВМ:

```sh
qm create 9020 --name OL9U2TPL --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
```

Монтируем образ:
```sh
qm set 9020 --scsi0 local-lvm:0,import-from=/tmp/OL9U2_x86_64-kvm-b197.qcow2
```

Подключаем Cloud-Init CD-ROM drive, что бы работал cloud-init
```sh
qm set 9020 --ide2 local-lvm:cloudinit
```

Указываем загрузку только с диска. Иначе по умолчанию пытается загрузиться по сети.
```sh
qm set 9020 --boot order=scsi0
```

Настройки дисплея для Oracle не меняем:
~~qm set 9000 --serial0 socket --vga serial0~~

Отключаем обновление системы при первом запуске
```sh
qm set ${VMID} --ciupgrade 0
```

И наконец делаем шаблон:
```sh
qm template 9020
```

Теперь можем создать ВМ. Из нашего шаблона клонируем ВМ и указываем cloud-init параметры. Но вместо использования qm можно использовать WEBUI или terraform
```sh
qm clone 9020 123 --name OL8VM1
qm set 123 --sshkey ~/.ssh/id_rsa.pub
qm set 123 --ipconfig0 ip=10.0.10.123/24,gw=10.0.10.1
```

И скрипт для Oracle Linux:
```bash
# Replace IMAGE_URL and VMID
IMAGE_URL=https://yum.oracle.com/templates/OracleLinux/OL8/u8/x86_64/OL8U8_x86_64-kvm-b198.qcow
VMID=8080

IMAGE_NAME=${IMAGE_URL##*/}2
TEMPLATE_NAME=$(echo $IMAGE_NAME | awk -F "_" '{print $1}')

wget $IMAGE_URL -O /tmp/${IMAGE_NAME}
qm create ${VMID} --name ${TEMPLATE_NAME}TPL --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set ${VMID} --scsi0 local-lvm:0,import-from=/tmp/${IMAGE_NAME}
qm set ${VMID} --ide2 local-lvm:cloudinit
qm set ${VMID} --boot order=scsi0
qm set ${VMID} --ciupgrade 0
qm template ${VMID}
```

Скрипт для Fedora:
```bash
# Replace IMAGE_URL, VMID and TEMPLATE_NAME
IMAGE_URL=https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2
VMID=3816
TEMPLATE_NAME="FEDORA3816"

IMAGE_NAME=${IMAGE_URL##*/}

wget $IMAGE_URL -O /tmp/${IMAGE_NAME}
qm create ${VMID} --name ${TEMPLATE_NAME}TPL --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set ${VMID} --scsi0 local-lvm:0,import-from=/tmp/${IMAGE_NAME}
qm set ${VMID} --ide2 local-lvm:cloudinit
qm set ${VMID} --boot order=scsi0
qm template ${VMID}
```
