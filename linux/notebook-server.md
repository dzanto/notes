---
title: "Как сделать из ноутбука сервер"
date: 2023-07-17T09:00:00+03:00
draft: false
tags: [linux, gnome]
---

### В секцию daemon добавляем параметры для автоматического входа в систему:
```sh
sudo vi /etc/gdm/custom.conf
```
```ini
[daemon]
AutomaticLoginEnable=False
AutomaticLogin=ashishlin
```

### Отключаем режим сна в настройках GNOME
Параметры gsettings настраиваем от пользователя с AutomaticLogin(НЕ от root!)
```sh
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
gsettings set org.gnome.desktop.screensaver lock-enabled false
```

### Отключаем спящий режим при закрытии экрана ноубука /etc/systemd/logind.conf
```sh
sudo echo "HandleLidSwitch=ignore" >> /etc/systemd/logind.conf
```

reboot
