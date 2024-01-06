---
title: "libvirt"
date: 2023-06-13T09:14:00+03:00
draft: false
tags: [libvirt]
---
Для запуска libvirt от обычного пользователя необходимо его жобавить в групуп libvirt
```sh
usermod -a -G libvirt  <user>
```
