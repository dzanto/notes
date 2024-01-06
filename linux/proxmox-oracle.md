---
title: "Запуск cloud-init Oracle Linux в Proxmox"
date: 2023-05-29T12:00:00+03:00
draft: false
tags: [proxmox]
categories: ["virtualization"]
---
Страница загрузки официальных образов Oracle Linux cloud image: https://yum.oracle.com/oracle-linux-templates.html, там же можно найти образы ISO, Vagrant и docker контейнеры.

Подключаемся к хосту Proxmox по ssh
Скачиваем образ в формате qcow на хост Proxmox:
```console
wget https://yum.oracle.com/templates/OracleLinux/OL8/u7/x86_64/OL8U7_x86_64-kvm-b148.qcow
```

У меня версия 9.1 не запустилась, по этому использовал 8.7

Необходимо изменить расширение у образа OL8U7_x86_64-kvm-b148.qcow на OL8U7_x86_64-kvm-b148.qcow2 иначе будет ошибка:

> qemu-img: Could not open '/tmp/OL8U7_x86_64-kvm-b148.qcow': qcow (v1) does not support qcow version 3
Try the 'qcow2' driver instead.

Далее следуем инструкции из документации Proxmox: https://pve.proxmox.com/wiki/Cloud-Init_Support

Создаем ВМ:
```console
qm create 9000 --name OL8TPL --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
```

Монтируем образ:
```console
qm set 9000 --scsi0 local-lvm:0,import-from=/tmp/OL8U7_x86_64-kvm-b148.qcow2
```

Настройки дисплея для Oracle не меняем:
```console
qm set 9000 --serial0 socket --vga serial0
```

Делаем шаблон:
```console
qm template 9000
```

Далее из нашего шаблона клонируем ВМ и указываем cloud-init параметры:
```console
qm clone 9000 123 --name OL8VM1
qm set 123 --sshkey ~/.ssh/id_rsa.pub
qm set 123 --ipconfig0 ip=10.0.10.123/24,gw=10.0.10.1
```