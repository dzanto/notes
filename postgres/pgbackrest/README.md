# pgBackRest

Все действия выполняем из под пользователя postgres
> sudo su postgres

Список бэкапов
> pgbackrest info

Удалить бэкапы, оставить только последний фулл и его инкрементальные бэкапы
> pgbackrest --stanza=main --repo1-retention-full=1 expire
