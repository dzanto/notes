---
title: "SELinux"
date: 2023-05-27T22:53:47+03:00
draft: false
tags: [linux, selinux]
categories: ["linux"]
---
`sestatus` и `getenforce` показывают статус SELinux
`enforcing` - блокирует
`permissive` - Пишет сообщения но не блокирует
`disabled` - отключен

Текущий режим можно поменять в /etc/selinux/config - изменения вступят в силу после перезагрузки.

Что бы сразу отключить/включить выполняем команду `setenforce 0` и `setenforce 1`

Просмотр логов SELinux: `sudo journalctl -e`

## Контекст SELinux
Пользователи, процессы и файлы имеют контекст SELinux
Можно его посмотреть с помощью команд
```bash
id
ps -Z
ls -Z
```
Пример вывода:
```bash
context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
unconfined_u:object_r:user_home_t:s0 file.txt
```
В конце символы с подчеркиванием:
```
_u - юзер
_r - роль
_t - тип
S0 - MLS политики, они не используются
```
### Пользователи SELinux
Просмотр пользователей:
``` bash
sudo semanage login -l
```
Вывод:
```
Login Name           SELinux User         MLS/MCS Range        Service

__default__          unconfined_u         s0-s0:c0.c1023       *
root                 unconfined_u         s0-s0:c0.c1023       *
```
Здесь пользователю root и __default__ соответствует SELinux User unconfined_u. __default__ - это все остальные пользователи. Никаких ограничений по пользователям по умолчанию нет.

Выведем список SELinux users и Roles которм они принадлежат:
```bash
sudo semanage user -l
```

Выведем список портов
```bash
sudo semanage port -l
# или
sudo semanage port -l | grep http
```
Мы увидим что для типа http_port_t разрешены порты tcp 80, 81, 443, 488, 8008, 8009, 8443, 9000

Выведем список файлов:
```bash
sudo semanage fcontext -l
```

## Изменение правил
Допустим мы изменили порт на котором слушает ssh на 2233. ssh не сможет запуститься, т.к. SELinux заблокирует.
Что бы решить это:
```bash
semanage port -a -t ssh_port_t -p tcp 2233
```
Для временной смены контекста файлов используется команда `chcon`
```bash
chcon unconfined_u:object_r:user_home_t:s0 /home/dzanto/file.txt
chcon -t container_file_t /usr/sbin/iscsiadm # здесь меняем только тип
```

Для постоянной смены контекста используется команда `semanage fcontext` + `chcon`(или `restorecon` вместо `chcon`)
```bash
semanage fcontext -at httpd_sys_rw_content_t /full_path/to/file.txt
chcon -t httpd_sys_rw_content_t /full_path/to/file.txt
```

Восстановить контекст файла по умолчанию из политик (`semanage fcontext -l`)
```bash
restorecon -v /var/www/html/index.html 
```
`-R` - рекусривно восстановить контекст файлов

## chcon vs semanage fcontext
`chcon` - Используется как временное решение. Временно меняет контекст. Контекст может быть восстановлен на дефолтный с помщью команды `restorecon`
`semanage fcontext` - меняет контекст в политике(`semanage fcontext -l`), а не сразу в файле. Что бы контекс применился к файлу необходимо дополнительно выполнить `chcon` или `restorecon`


## SELinux boolean
Просмотр boolean
```sh
semanage boolean -l
# или
getsebool -a
```

Установить boolean в политику
```sh
setsebool mozilla_plugin_use_gps on -P
```
Без ключа `-P` правило будет действовать только в текущей сессии

## Экспортировать изменения SELinux
```sh
semanage export -f my-selinux.txt
```

Импорт
```sh
semanage import -f my-selinux.txt
```

## Логи SElinux

Логи находятся в /var/log/audit/audit.log

Посмотреть ошибки selinux, с рекомендациями для исправления
sealert -a /var/log/audit/audit.log

# Ansible модуль для управления SELinux
https://docs.ansible.com/ansible/latest/collections/community/general/sefcontext_module.html
