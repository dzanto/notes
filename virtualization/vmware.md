---
title: "Создание шаблона ВМ для vsphere"
date: 2023-06-13T09:14:00+03:00
draft: false
tags: [vmware]
---
```sh
vmware-toolbox-cmd config get deployPkg enable-custom-scripts
vmware-toolbox-cmd config set deployPkg enable-custom-scripts true
vmware-toolbox-cmd config get deployPkg enable-custom-scripts
```
