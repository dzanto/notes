---
title: "Работа с ssh"
date: 2023-06-05T17:00:00+03:00
draft: false
tags: [ssh]
---
### Local Port Forwarding
Перенаправить localhost:80 расположенный на dzanto.ru, на текущую машину с портом 8080.
```bash
ssh -L 8080:localhost:80 dzanto.ru
```

### Jump host
Подключиться к host2 через host1
```bash
ssh -J host1 host2
```
