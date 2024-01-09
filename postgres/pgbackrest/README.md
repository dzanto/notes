# pgBackRest

Все действия выполняем из под пользователя postgres
> sudo su postgres

Список бэкапов
> pgbackrest info

Удалить бэкапы, оставить только последний фулл и его инкрементальные бэкапы
> pgbackrest --stanza=main --repo1-retention-full=1 expire

Добавляем в crontab postgres пользователя
```
30 03  *   *   0    /var/lib/pgbackrest/backup.sh full
30 03  *   *   1-6  /var/lib/pgbackrest/backup.sh incr
```

Пример конфига /etc/pgbackrest.conf
```conf
[main]
pg1-path=/var/lib/pgsql/14/data/
pg1-port=5432
pg1-host=postgres-1.example.ru
pg1-socket-path=/var/run/postgresql/
pg2-path=/var/lib/pgsql/14/data/
pg2-port=5432
pg2-host=postgres-2.example.ru
pg2-socket-path=/var/run/postgresql/
pg3-path=/var/lib/pgsql/14/data/
pg3-port=5432
pg3-host=postgres-4.example.ru
pg3-socket-path=/var/run/postgresql/
pg4-path=/var/lib/pgsql/14/data/
pg4-port=5432
pg4-host=postgres-5.example.ru
pg4-socket-path=/var/run/postgresql/

[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
start-fast=y
```
