---
title: "Kubeplay - установка kubernetes offline"
date: 2023-05-29T12:08:00+03:00
draft: false
tags: [k8s]
categories: ["kubernetes"]
---
Для установки будем использовать kubeplay - https://github.com/k8sli/kubeplay

Требования:
1. kubeplay должен запускаться НЕ на ноде предназначенной для k8s кластера.
2. ОС на нодах кластера должны соответствовать версии kubeplay

Скачиваем актуальный архив из https://github.com/k8sli/kubeplay/releases
```console
wget https://github.com/k8sli/kubeplay/releases/download/v0.1.2/kubeplay-v0.1.2-ubuntu-2004-amd64.tar.gz
```

Распаковываем и редактируем конфиг:
```console
tar -xpf kubeplay-x.y.z-xxx-xxx.tar.gz
cd kubeplay
cp config-sample.yaml config.yaml
nano config.yaml
```

В конфиге необходимо изменить параметры:
1. `internal_ip: <IP адрес узла на котором запускается kubeplay>`
2. В случае использования ssh ключа в разделе inventory закомментировать 
     `ansible_ssh_pass: Password`. И раскомментировать
 `ansible_ssh_private_key_file: /kubespray/config/id_rsa`. Сам ключ необходимо скопировать в директорию `./kubeplay/config/kubespray/id_rsa`
3. В разделе `inventory` указать ноды кластера и их ip адреса
Установка запускается командой:
```console
bash install.sh
```
После выполнения установки, получаем готовый k8s кластер
