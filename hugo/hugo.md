---
title: "Hugo"
date: 2023-05-29
# weight: 1
draft: false
categories: ["hugo"]
tags: ["hugo"]
---
Если переносили hugo в /usr/local/bin из домашней директории может возникнуть ошибка:
> type=AVC msg=audit(1685198704.731:31444): avc: denied { execute } for pid=15720 comm="(hugo)" name="hugo" dev="dm-0" ino=8975663 scontext=system_u:system_r:init_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0

>If you want to fix the label. /usr/local/bin/hugo default label should be bin_t.

настраиваем selinux:
```
restorecon -v /usr/local/bin/hugo
```

Устанавливаем шаблон PaperMod
```
git submodule add -f https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
```

Создаем сервис
```
vi /etc/systemd/system/hugo.service
```
со следующим содержимым:
```
[Unit]
Description=Hugo server
After=syslog.target network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/hugo server --source /opt/www/dzanto --appendPort=false --baseURL http://<my-ip-adress> --bind 0.0.0.0
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```
