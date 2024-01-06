---
title: "Примеры работы с bash"
date: 2023-10-13T09:00:00+03:00
draft: false
tags: [bash]
---
Перезагрузить несколько хостов
```sh
for host in host{1..3}.dzanto.ru; do ssh $host "sudo reboot"; done
```
