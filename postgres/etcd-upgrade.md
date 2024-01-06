---
title: "Обновление etcd кластера и генерация сертификатов c subjectAltName"
date: 2023-06-04T12:42:00+03:00
draft: false
tags: [etcd, openssl, patroni]
---
# Обновление etcd кластера
1. Перед запуском читаем release notes
2. Проверяем наличие параметра `serial: 1` в плейбуке

## Генерация сертификатов для etcd/patroni c subjectAltName
Начиная с версии go 1.15 (etcd >=3.4.19, etcd >=3.5.0) в сертификатах требуется запись subjectAltName

### Генерируем CA

    openssl genrsa -out ca.key 4096

    openssl req -x509 -new \
	    -subj "/CN=etcd-ca-infra" \
        -key ca.key -days 9999 -out ca.crt

### Генерируем private key for hosts

    openssl genrsa -out postgres1.infra.int.my-dev.ru.key 2048
    openssl genrsa -out postgres2.infra.int.my-dev.ru.key 2048
    openssl genrsa -out pdns2.infra.int.my-dev.ru.key 2048

### Генерируем csr for hosts

    openssl req -new -key postgres1.infra.int.my-dev.ru.key \
        -subj "/CN=postgres1.infra.int.my-dev.ru" \
        -addext "subjectAltName = DNS:postgres1.infra.int.my-dev.ru" \
        -out postgres1.infra.int.my-dev.ru.csr

    openssl req -new -key postgres2.infra.int.my-dev.ru.key \
        -subj "/CN=postgres2.infra.int.my-dev.ru" \
        -addext "subjectAltName = DNS:postgres2.infra.int.my-dev.ru" \
        -out postgres2.infra.int.my-dev.ru.csr

    openssl req -new -key pdns2.infra.int.my-dev.ru.key \
        -subj "/CN=pdns2.infra.int.my-dev.ru" \
        -addext "subjectAltName = DNS:pdns2.infra.int.my-dev.ru" \
        -out pdns2.infra.int.my-dev.ru.csr

### Генерируем certs for hosts

    openssl x509 -req -in postgres1.infra.int.my-dev.ru.csr -CA ca.crt -CAkey ca.key \
        -extfile <(echo "subjectAltName=DNS:postgres1.infra.int.my-dev.ru") \
        -CAcreateserial -out postgres1.infra.int.my-dev.ru.crt -days 9999

    openssl x509 -req -in postgres2.infra.int.my-dev.ru.csr -CA ca.crt -CAkey ca.key \
        -extfile <(echo "subjectAltName=DNS:postgres2.infra.int.my-dev.ru") \
        -CAcreateserial -out postgres2.infra.int.my-dev.ru.crt -days 9999

    openssl x509 -req -in pdns2.infra.int.my-dev.ru.csr -CA ca.crt -CAkey ca.key \
        -extfile <(echo "subjectAltName=DNS:pdns2.infra.int.my-dev.ru") \
        -CAcreateserial -out pdns2.infra.int.my-dev.ru.crt -days 9999

### Проверяем сертификаты
    openssl x509 -in postgres1.infra.int.my-dev.ru.crt -text -noout

Должен пристутствовать параметр:

    Subject Alternative Name: 
    DNS:postgres1.infra.int.my-dev.ru
---
## Замена сертификатов на хостах

### Копируем сертификаты на хосты
    scp postgres1.infra.int.my-dev.ru.{crt,key} ca.crt postgres1.infra.int.my-dev.ru:~
    scp postgres2.infra.int.my-dev.ru.{crt,key} ca.crt postgres2.infra.int.my-dev.ru:~
    scp pdns2.infra.int.my-dev.ru.{crt,key} ca.crt pdns2.infra.int.my-dev.ru:~

### postgres1
    cp -rp /etc/patroni ~/
    cp -rp /var/lib/etcd/patroni-infra.pki ~/

    cat ./postgres1.infra.int.my-dev.ru.crt > /etc/patroni/pki/postgres1.infra.int.my-dev.ru.crt
    cat ./postgres1.infra.int.my-dev.ru.crt > /var/lib/etcd/patroni-infra.pki/postgres1.infra.int.my-dev.ru.crt

    cat ./postgres1.infra.int.my-dev.ru.key > /etc/patroni/pki/postgres1.infra.int.my-dev.ru.key
    cat ./postgres1.infra.int.my-dev.ru.key > /var/lib/etcd/patroni-infra.pki/postgres1.infra.int.my-dev.ru.key

    cat ./ca.crt > /etc/patroni/pki/ca.crt
    cat ./ca.crt > /var/lib/etcd/patroni-infra.pki/ca.crt

### postgres2
    cp -rp /etc/patroni ~/
    cp -rp /var/lib/etcd/patroni-infra.pki ~/

    cat ./postgres2.infra.int.my-dev.ru.crt > /etc/patroni/pki/postgres2.infra.int.my-dev.ru.crt
    cat ./postgres2.infra.int.my-dev.ru.crt > /var/lib/etcd/patroni-infra.pki/postgres2.infra.int.my-dev.ru.crt

    cat ./postgres2.infra.int.my-dev.ru.key > /etc/patroni/pki/postgres2.infra.int.my-dev.ru.key
    cat ./postgres2.infra.int.my-dev.ru.key > /var/lib/etcd/patroni-infra.pki/postgres2.infra.int.my-dev.ru.key

    cat ./ca.crt > /etc/patroni/pki/ca.crt
    cat ./ca.crt > /var/lib/etcd/patroni-infra.pki/ca.crt

### pdns2
    cp -rp /var/lib/etcd/patroni-infra.pki ~/

    cat ./pdns2.infra.int.my-dev.ru.crt > /var/lib/etcd/patroni-infra.pki/pdns2.infra.int.my-dev.ru.crt
    cat ./pdns2.infra.int.my-dev.ru.key > /var/lib/etcd/patroni-infra.pki/pdns2.infra.int.my-dev.ru.key
    cat ./ca.crt > /var/lib/etcd/patroni-infra.pki/ca.crt

### Рестартим etcd и patroni
    systemctl restart etcd
    systemctl restart patroni

### Проверяем состояние

    /usr/local/bin/etcdctl --write-out=table endpoint status \
        --endpoints=postgres1.infra.int.my-dev.ru:2379,postgres2.infra.int.my-dev.ru:2379,pdns2.infra.int.my-dev.ru:2379 \
        --cert /etc/patroni/pki/postgres1.infra.int.my-dev.ru.crt \
        --key /etc/patroni/pki/postgres1.infra.int.my-dev.ru.key \
        --cacert /etc/patroni/pki/ca.crt

    /usr/local/bin/etcdctl endpoint health \
        --endpoints=postgres1.infra.int.my-dev.ru:2379,postgres2.infra.int.my-dev.ru:2379,pdns2.infra.int.my-dev.ru:2379 \
        --cert /etc/patroni/pki/postgres1.infra.int.my-dev.ru.crt \
        --key /etc/patroni/pki/postgres1.infra.int.my-dev.ru.key \
        --cacert /etc/patroni/pki/ca.crt

    /usr/local/bin/patronictl -c /etc/patroni/postgres1.infra.int.my-dev.ru.yml list
