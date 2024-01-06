# pgBackRest

Список бэкапов
> pgbackrest info

Удалить бэкапы, оставить только последний фулл и его инкрементальные бэкапы
> pgbackrest --stanza=main --repo1-retention-full=1 expire
