---
title: "Устранение ошибки верификации Let's Encrypt сертификата"
date: 2023-06-04T09:00:00+03:00
draft: false
tags: [ssl]
---
Например, если curl выдает ошибку:
>curl: (60) server certificate verification failed

необходимо отключить(поставить ! в начале строки) использование сертификата `DST_Root_CA_X3.crt` в `/etc/ca-certificates.conf`:
```
!mozilla/DST_Root_CA_X3.crt
```
и обновить bandle файл `/etc/ssl/certs/ca-certificates.crt` с сертификатами:
```
sudo update-ca-certificates
```
Вместо `update-ca-certificates` можно попробовать вручную удалить сертификат из `/etc/ssl/certs/ca-certificates.crt`
