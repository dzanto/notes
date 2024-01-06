---
title: "Как использовать DNS от нескольких VPN соединений"
date: 2023-06-04T14:42:00+03:00
draft: false
tags: [vpn, NetworkManager, dns]
---
Устанавливаем openconnect вместо CISCO AnyConnect
```
apt install network-manager-openconnect-gnome
```

Настройка NetworkManager
Добавьте в файл `/etc/NetworkManager/NetworkManager.conf` в секцию [main] строку  `dns=dnsmasq`

Настройка dnsmasq
Создайте файл `/etc/NetworkManager/dnsmasq.d/dnsmasq.conf` в котором указываем какие зоны каким dns должны обрабатываться:
```
server=/first.domain/dns-server-one
server=/second.domain/dns-server-two
 
server=/int.my-dev.ru/dns-server-three
server=/stage.my-dev.ru/three
```
рестартим `sudo systemctl restart NetworkManager` и проверям, что все запустилось успешно `sudo systemctl status NetworkManager`

Отключаем systemd-resolved
```
sudo systemctl disable systemd-resolved.service
```
