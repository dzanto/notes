# Работа с пользователями

- \du - список пользователей или `SELECT usename FROM pg_catalog.pg_user;`
- `SELECT rolname FROM pg_roles;` - список ролей

Изменить пароль пользователя
```sql
ALTER USER "user_name" WITH PASSWORD 'new_password';
```
