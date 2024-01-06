---
title: "Запуск keycloak в docker"
date: 2023-06-05T16:00:00+03:00
draft: false
tags: [keycloak]
---
Подготовим `/opt/keycloak/docker-compose.yml`
```yml
version: '3.9'

services:
  postgres:
    image: postgres:15.3
    environment:
      POSTGRES_DB: ${POSTGRESQL_DB}
      POSTGRES_USER: ${POSTGRESQL_USER}
      POSTGRES_PASSWORD: ${POSTGRESQL_PASS}

  keycloak:
    image: quay.io/keycloak/keycloak:latest
    command: start
    depends_on:
      - postgres
    environment:
      DB_VENDOR: postgres
      DB_ADDR: postgres
      DB_DATABASE: ${POSTGRESQL_DB}
      DB_USER: ${POSTGRESQL_USER}
      DB_PASSWORD: ${POSTGRESQL_PASS}
      KEYCLOAK_ADMIN: ${KEYCLOAK_ADMIN}
      KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD}
      KC_HOSTNAME_STRICT: false #https://unix.stackexchange.com/questions/690655/strict-hostname-resolution-configured-but-no-hostname-was-set
      KC_HTTP_ENABLED: true

    ports:
      - "8080:8080"
```

и `/opt/keycloak/.env` файл:
```bash
POSTGRESQL_USER=keycloak
POSTGRESQL_PASS=keycloak
POSTGRESQL_DB=keycloak
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=change_me
```

Запускаем:
```bash
sudo docker compose up -d
```
