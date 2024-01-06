---
title: "Скрипт удаления пользователя PostgreSQL"
date: 2023-06-13T09:14:00+03:00
draft: false
tags: [postgres]
---
Пытаемся удалить
```sql
DROP USER "<username>";
```
Получаем ошибку `ERROR:  role "<username>" cannot be dropped because some objects depend on it` с указанием зависимостей

Для каждой БД в которой есть зависимости выполняем скрипт:
```bash
PG_DATABASE="<db_name>"
PG_REMOVE_USER="<username>"

alias psql-c="psql --dbname=\"$PG_DATABASE\" --tuples-only -c"
cd ~

psql-c "REASSIGN OWNED BY \"$PG_REMOVE_USER\" TO postgres;"
psql-c "REVOKE ALL PRIVILEGES ON DATABASE \"$PG_DATABASE\" FROM \"$PG_REMOVE_USER\";"

psql-c "SELECT schema_name FROM information_schema.schemata;" | while read SCHEMANAME
do
    if [ "$SCHEMANAME" != "" ]; then
        psql-c "REVOKE ALL PRIVILEGES ON SCHEMA \"$SCHEMANAME\" FROM \"$PG_REMOVE_USER\";"
        psql-c "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA \"$SCHEMANAME\" FROM \"$PG_REMOVE_USER\";"
        psql-c "REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA \"$SCHEMANAME\" FROM \"$PG_REMOVE_USER\";"
        psql-c "REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA \"$SCHEMANAME\" FROM \"$PG_REMOVE_USER\";"
    fi
done
```

Повторяем попытку удаления:
```sql
DROP USER "<username>";
```
