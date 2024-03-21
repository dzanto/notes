# sftp

Если не хватает прав для копирования файла с помощью scp, можно запустить sftp-server от root пользователя
```sh
sftp -s 'sudo -u root /usr/libexec/openssh/sftp-server' remote.host.ru
get /full/remote/path/file.txt /full/local/path/
```

То же самое в одну команду для скриптов
```sh
sftp -s 'sudo -u root /usr/libexec/openssh/sftp-server' remote.host.ru << EOF
  get /var/lib/pgsql/test_keycloak-2024-02-06.sql /home/my-user
EOF
```
