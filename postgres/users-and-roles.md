# Работа с пользователями

- \du - список пользователей или `SELECT usename FROM pg_catalog.pg_user;`
- `SELECT rolname FROM pg_roles;` - список ролей

Создание пользователя
```sql
CREATE ROLE admin LOGIN SUPERUSER PASSWORD 'superpassword';
```

Удаление пользователя
```sql
DROP USER "my_user";
# Может ругнуться на то что не может удалить
REASSIGN OWNED BY "my_user" TO postgres;
REASSIGN OWNED BY "my_user" TO postgres ON SCHEMA "my_schema";

REVOKE ALL PRIVILEGES ON DATABASE mydb FROM "XUSER";
REVOKE ALL PRIVILEGES ON SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA myschem FROM "XUSER";
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA myschem FROM "XUSER";

REVOKE ALL ON SCHEMA "my_schema" FROM "my_user";
REVOKE ALL ON ALL TABLES IN SCHEMA "my_schema" FROM "my_user";
REVOKE ALL ON DATABASE "my_db" FROM "my_user";
REVOKE ALL PRIVILEGES ON SCHEMA "my_schema" FROM "my_user";
```

Добавление прав
```sql
GRANT ALL PRIVILEGES ON DATABASE "my_db" to "my_user";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "my_user";
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "my_role"; --только чтение
```

Просмотр прав
```sql
SELECT * FROM information_schema.table_privileges WHERE grantee = 'my_role';
```

Изменить пароль пользователя
```sql
ALTER USER "user_name" WITH PASSWORD 'new_password';
```

Добавить роль для пользователя
```sql
GRANT "my_role" TO "my_user";
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
CREATE DATABASE "my_db" WITH OWNER "my_user";
```

Сменить владельца таблицы
```sql
ALTER TABLE my_schema.my_table OWNER TO my_user;
```
