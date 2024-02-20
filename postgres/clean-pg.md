Удаление старых логов Postgres
```sh
/usr/pgsql-14/bin/pg_controldata -D /var/lib/pgsql/14/data/postgresql1/ | grep 'REDO WAL'
/usr/pgsql-14/bin/pg_archivecleanup  /var/lib/pgsql/14/data/postgresql1/pg_wal/  <Latest checkpoint's REDO WAL file>
```
