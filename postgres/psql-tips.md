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

# Обновление данных. Команда UPDATE
https://metanit.com/sql/postgresql/3.4.php

```sql
UPDATE имя_таблицы
SET столбец1 = значение1, столбец2 = значение2, ... столбецN = значениеN
[WHERE условие_обновления]
```

Пример:
```sql
UPDATE my_schema.my_table
SET my__first_parametr = true, my__second_parametr ='100'
WHERE id in (
'ab84-4395-97f8',
'2bdd-44d3-ac83',
'f457-494c-a12a'
);
```

Просмотр запущеных процессов
```sql
SELECT * from pg_stat_activity where state='active';
```
Удалить транзакцию(процесс)
```sql
SELECT pg_cancel_backend(<pid>)
SELECT pg_terminate_backend(<pid>);
```

Безопасное выполнение запросов в psql
```sql
begin;
сам запрос;
/* если всё выглядит плохо */
rollback;
/* если выглядит нормально */
commit;
```

Безопасное выполнение запросов в Dbeaver - выключить `Auto-commit` в настройках базы `Edit connection/Connection settings/Initialization/Auto-commit`

Копирование из csv файла.
Предварительно нужно создать таблицу с соотвествующими типами колонок.
```
"n","number"
1,"10204110000010571695"
2,"10204110000010574237"
3,"10204110000010574291"
```

```sql
COPY my_schema.my_table(first,second)
FROM '/home/postgres/my.csv'
DELIMITER ','
CSV HEADER;
```

Можно не указывать имена колонок (first,second), тогда они возьмутся из первой строки csv.
