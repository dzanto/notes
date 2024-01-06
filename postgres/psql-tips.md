# Шпаргалка по psql

### Подключение
Подключаться необходимо к мастеру. Мастера можно узнать в patroni или в дашборде grafana
```sh
ssh postgres-4
sudo su postgres
psql
```

### Основные команды
- \l - список баз
- \du - список пользователей или `SELECT usename FROM pg_catalog.pg_user;`
- `SELECT rolname FROM pg_roles;` - список ролей
- \с bd_name - переключиться на базу
- \dn - список схем

### Создание пользователя
```sql
CREATE ROLE admin LOGIN SUPERUSER PASSWORD 'superpassword';
```

### Удаление пользователя
```sql
DROP USER <user>;
# Может ругнуться на то что не может удалить
REASSIGN OWNED BY <user> TO postgres;
REASSIGN OWNED BY <user> TO postgres ON SCHEMA <schema_name>;

REVOKE ALL PRIVILEGES ON DATABASE mydb FROM "XUSER";
REVOKE ALL PRIVILEGES ON SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA myschem FROM "XUSER";

REVOKE ALL ON SCHEMA <schema_name> FROM <user>;
REVOKE ALL ON ALL TABLES IN SCHEMA <schema_name> FROM <user>;
REVOKE ALL ON DATABASE <database> FROM <user>;
REVOKE ALL PRIVILEGES ON SCHEMA <schema_name> FROM <user>;
```

### Добавление прав
```sql
GRANT ALL PRIVILEGES ON DATABASE "my_db" to my_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "my_user";
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "my_role"; --только чтение
```

# Просмотр прав
```sql
SELECT * FROM information_schema.table_privileges WHERE grantee = 'my_role';
```

# Обновление данных. Команда UPDATE
https://metanit.com/sql/postgresql/3.4.php

```
UPDATE имя_таблицы
SET столбец1 = значение1, столбец2 = значение2, ... столбецN = значениеN
[WHERE условие_обновления]
```

Пример:
```sql
UPDATE sheduler.draw
SET is_promotional = true, limit_promotional_tickets ='100'
WHERE id in (
'ab84-4395-97f8',
'2bdd-44d3-ac83',
'f457-494c-a12a'
);
```

Создание БД и пользователя:

```sql
CREATE ROLE "my_user" WITH 
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	LOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;

GRANT "my_role" TO "my_user";

CREATE ROLE "my_role" LOGIN PASSWORD 'my_password';
CREATE DATABASE my_db WITH OWNER my_user;
```

Добавить роль для пользователя
```sql
GRANT "my_role" TO "my_user";
```


Удалить транзакцию
```sql
select * from pg_stat_activity where state='active';
SELECT pg_cancel_backend(<pid>)
select pg_terminate_backend(<pid>);
```
