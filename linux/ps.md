---
title: "ps"
date: 2023-05-29T11:00:47+03:00
draft: false
tags: [linux]
categories: ["linux"]
---
вывод отдельных колонок
```
ps -eo ppid,pid,user,stat,pcpu,comm,wchan:32 | grep " D"
```

Просмотр всех процессов и их state
```
ps a -ef
```
