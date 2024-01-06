---
title: "Комманды patroni"
date: 2023-09-28T09:14:00+03:00
draft: false
tags: [postgres, patroni]
---
Список хостов кластера
```sh
/usr/local/bin/patronictl -c /etc/patroni/core1.db.load.int.dzanto.ru.yml list
/usr/local/bin/patronictl -c /etc/patroni/core1.db.load.int.dzanto.ru.ru edit-config
```
Сменить мастера:
```sh
/usr/local/bin/patronictl -c /etc/patroni/core1.db.load.int.dzanto.ru.yml switchover
```
Дале несколько раз нажимаем Enter, при необходимости меняем параметры.

sudo systemctl status patroni


This error usually means that PostgreSQL's request for a shared memory segment exceeded available memory, swap space, or huge pages. To reduce the request size (currently 55002005504 bytes), reduce PostgreSQL's shared memory usage, perhaps by reducing shared_buffers or max_connections


echo 'vm.nr_hugepages = 26404' >> /etc/sysctl.d/30-postgresql.conf
echo 'vm.nr_hugepages_mempolicy = 26404' >> /etc/sysctl.d/30-postgresql.conf

sysctl -p --system