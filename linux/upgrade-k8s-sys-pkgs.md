---
title: "Обновление системных пакетов на k8s ноде"
date: 2023-06-05T09:00:00+03:00
draft: false
tags: [dnf, k8s]
---

1. Дрейним ноду
```bash
export NODE_NAME="worker11"
kubectl drain $NODE_NAME \
  --force \
  --delete-emptydir-data \
  --ignore-daemonsets \
  --pod-selector='app!=csi-attacher,app!=csi-provisioner'
```
2. Подключемся к хосту по ssh, обновляем docker на версию 20.10.X(т.к. RKE рекомендует https://rke.docs.rancher.com/os#general-linux-requirements) и фризим версию.
```bash
ssh $NODE_NAME
sudo dnf install -y 'dnf-command(versionlock)'
sudo dnf upgrade -y docker-ce-3:20.10.24 docker-ce-cli-1:20.10.24 docker-ce-rootless-extras-20.10.24
# или
# sudo dnf -y remove docker-buildx-plugin
# sudo dnf -y downgrade docker-ce-3:20.10.24 docker-ce-cli-1:20.10.24 docker-ce-rootless-extras-20.10.24
sudo dnf versionlock add docker-ce*
```
3. Обновляем остальные компоненты системы
```bash
sudo dnf -y upgrade
# на всякий случай смотрим сетевые настройки
sudo nmtui
sudo shutdown -h now
# или перезагружаем
# sudo reboot
```

4. Возвращаем ноду в работу
```bash
kubectl uncordon $NODE_NAME
```