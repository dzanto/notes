---
title: "Установка Vagrant и VirtualBox на Fedora"
date: 2023-07-06T09:14:00+03:00
draft: false
tags: [vagrant, virtualbox]
---
### Устанавливаем Vagrant и VirtualBox

Устанавливаем Vagrant из стандартного репозитория. И проверяем версию
```sh
sudo sudo dnf -y install vagrant
vagrant --version
```

Vagrant до версии 2.3.2 не работает с VirtualBox 7 версии.
https://github.com/hashicorp/vagrant/blob/v2.3.2/CHANGELOG.md

По этому качаем версию 6.1 https://www.virtualbox.org/wiki/Download_Old_Builds_6_1 и устанавливаем.

```sh
wget https://download.virtualbox.org/virtualbox/6.1.44/VirtualBox-6.1-6.1.44_156814_fedora36-1.x86_64.rpm
sudo dnf install VirtualBox-6.1-6.1.44_156814_fedora36-1.x86_64.rpm
```

### Запуск Vagrant с VirtualBox
Для запуска необходимо указать provider
```sh
vagrant up --provider virtualbox
```

Или добавить в начало Vagrantfile строку:
```ruby
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
```

### Проблемы
Отключить SecureBoot в BIOS

Если не поможет, дополнительно выполнить
```sh
sudo dnf -y install @development-tools
sudo dnf install kernel-headers kernel-devel dkms  -y
sudo /sbin/vboxconfig
```

### Опционально. Установка libvirt провайдера вместо VirtualBox

Команды взяты отсюда:
https://developer.fedoraproject.org/tools/vagrant/vagrant-libvirt.html

```sh
sudo dnf install vagrant-libvirt
sudo dnf install @vagrant
sudo systemctl enable libvirtd
```
