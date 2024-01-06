---
title: "Пакетный менеджер yum/dnf"
date: 2023-05-29T12:42:00+03:00
draft: false
tags: [linux, dnf]
categories: ["linux"]
---
### Полезные команды
Проверить установленные пакеты и их версии
```bash
sudo dnf list installed "docker-ce*"
```

Список доступных версий пакетов в репозитории
```bash
dnf list 'docker-ce*' --showduplicates
```

### Как заблокировать версию пакета в dnf
Устанавливаем versionlock
```bash
sudo dnf install 'dnf-command(versionlock)'
```
Фиксируем версию пакетов docker-ce*
```bash
sudo dnf versionlock add docker-ce*
```
Разблокируем
```bash
sudo dnf versionlock delete docker-ce*
```
