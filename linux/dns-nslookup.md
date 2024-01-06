---
title: "nslookup"
date: 2023-06-07T16:42:00+03:00
draft: false
tags: [dns]
---
Запрос A записи
```sh
nslookup -type=A yandex.ru
```

Ответ получим от DNS сервера 127.0.0.1
```
Server:		127.0.0.1

Non-authoritative answer:
Name:	yandex.ru
Address: 5.255.255.70
```
Запрос A записи у DNS сервера 1.1.1.1
```sh
nslookup -type=A yandex.ru 1.1.1.1
```
В обоих случаях получим Non-authoritative answer
```
Server:		1.1.1.1

Non-authoritative answer:
Name:	yandex.ru
Address: 77.88.55.88
```

## Как получить authoritative answer
Запрашиваем SOA запись:
```sh
nslookup -type=SOA yandex.ru
```
В ответе видим `origin = ns1.yandex.ru` - это DNS сервер который отвечает за зону `yandex.ru`:
```
Server:		127.0.0.1

Non-authoritative answer:
yandex.ru
	origin = ns1.yandex.ru
	mail addr = sysadmin.yandex-team.ru
	serial = 2023032325
	refresh = 600
	retry = 300
	expire = 2592000
	minimum = 900
```

Теперь делаем в запросе явно укажем DNS сервер 'ns1.yandex.ru':
```bash
nslookup -type=A yandex.ru ns1.yandex.ru
```
И получаем ответ без сообщения `Non-authoritative answer`
```
Server:		ns1.yandex.ru
Address:	213.180.193.1#53

Name:	yandex.ru
Address: 77.88.55.60
```

## Рекурсивный DNS сервер
- Рекурсивный DNS сервер - перенаправляет DNS запросы на другие сервера
- Не рекурсивный - отвечает только за свою зону, и не перенаправялет запросы.
