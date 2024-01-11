Создание и удаление таблицы
```sql
CREATE TABLE my_schema.my_table
(
	first varchar,
	second  varchar,
    number varchar,
    comb text,
    other character(1)
);

DROP TABLE my_schema.my_table;

-- TRUNCATE - Удаление всех данных из таблицы. В отличие от DROP TABLE нет необходимости настраивать права.
TRUNCATE TABLE my_schema.my_table;
```
