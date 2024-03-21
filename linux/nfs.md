# Network File System

## Server
Установим и запустим nfs-server
```sh
sudo su
dnf install nfs-utils
systemctl enable --now nfs-server
systemctl status nfs-server
```

Настроим firewall
```sh
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
firewall-cmd --list-all
firewall-cmd --info-service=nfs
ss -tl4n
# t - tcp
# l - listern
# 4 - ipv4
# n - show port number
# nfs-server работает на порту 2049
```

Создадим дирректорию(шару) и файлы для раздачи
```sh
mkdir /data
touch /data/file{1..3}
```

Список расшаренных директорий находится в файле `/etc/exports` или в директории `/etc/exports.d/`

Откроем read-write доступ к дирректории `/data` для ip `192.168.31.5`
```
/data 192.168.31.5(rw)
```

Применим настройки
```sh
exportfs -av
# v - verbose
# a - перечитать и применить настройки из /etc/exports
```

Просмотр текущих шар. Ключ `-s` показывает подробные параметры
```sh
exportfs
exportfs -s
```

## Client

Примонтируем шару `/data` находящуюся на нашем сервере `192.168.31.205` в каталог `/mnt`
```sh
sudo mount 192.168.31.205:/data /mnt
```

`df -h /mnt/` - покажет размер диска с сервера

`mount | grep /mnt` - посмотреть параметры монтирования

## Управление правами

Права root по умолчанию игнорируются, т.е. клиентский root не может менять файлы в шаре.

no_root_squash в /etc/exports позволяет работать клиенту от root пользователя
```
/data 192.168.31.5(rw,no_root_squash)
```

Применим настройки
```sh
exportfs -rv
# v - verbose
# r - заново расшарить существующую шару с новыми параметрами
```

### Авто монтирование
Добавить в /etc/fstab
```
192.168.31.205:/data    /mnt    nfs defaults,nofail     0   0
```
nofail - если сеть будет недоступна, то система запустится без монтирования шары. Если не указать то система не загрузится, при недоступности шары.

mount -a

### /etc/exports

Различные настройки /data для разных сетей
```
/data 192.168.31.5(rw,no_root_squash) 192.168.31.0(rw)
/data/newdata *(ro)
```

Применим настройки
```sh
exportfs -rv
# v - verbose
# r - заново расшарить существующую шару с новыми параметрами
```

### showmount

`showmount -e 192.168.31.205` - посомтреть с клиента, какие шары есть на сервере

Для этого на сервере неоходимо открыть порты:
```sh
firewall-cmd --add-service={rpc-bind,mountd} --permanent
firewall-cmd --reload
```

Принудительно отмонтировать шару, если шара стала недоступна. 
```sh
umount -f -l /mnt
# -f - Force an unmount (in case of an unreachable NFS system)
# -l - Lazy unmount. Detach the filesystem from the file hierarchy now.
# После чего необходимо перезагрузиться.
```