---
title: "Дергается, лагает видео в Linux"
date: 2023-09-19T14:42:00+03:00
draft: false
tags: [video]
---
Устанавливаем кодек ffmpeg-libs
```
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install ffmpeg-libs
```
