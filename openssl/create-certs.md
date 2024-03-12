Создаем приватный ключ для корневого сертификата
```sh
openssl genrsa -out ca.key 4096
```

Если добавить параметр `-aes256`, ключ будет создан с паролем
```sh
openssl genrsa -aes256 -out ca.key 4096
```

Создаем корневой сертификат, указываем срок действия и subject. В subject не должно быть кириллицы.
```sh
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj '/emailAddress=noreply@example.invalid/ST=Moscow/O=OOO_My_company_name/L=Moscow/CN=purpose-mtls-ca/C=RU'
```

    CN - Common Name
    C - Country Name (2 letter code)
    ST - State or Province Name
    L - Locality Name
    O - Organization Name
    emailAddress - Email Address

