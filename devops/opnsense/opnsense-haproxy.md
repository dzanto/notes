# OpnSesne HAproxy

Настройки HAproxy находится в разделе `Services/HAProxy/Settings`

Добавляем Real Servers (Settings/Real Servers/Real Servers)
```yml
Name or Prefix: nexus_docker_dev
# ip адрес и порт сервера назначения
FQDN or IP: 10.240.240.35
Port: 10001
```

Добавляем Backend Pool (Settings/Virtual Services/Backend Pool)
```yml
Name: nexus_docker_dev_backend
Servers: nexus_docker_dev (Выбираем сервер из Real Servers)
```

Добавляем Condition (Settings/Rules&Checks/Conditions)
```yml
Name: nexus_docker_dev_acl
Condition type: Host matches
Host String: nl-docker-dev.nexus.dzanto.ru
```

Добавляем Rules (Settings/Rules&Checks/Rules)
```yml
Name: nexus_docker_dev_frontend
# Выбираем Condition из предыдущего шага (Settings/Rules&Checks/Conditions)
Select conditions: nexus_docker_dev_acl
# Выбираем backend pool из (Settings/Virtual Services/Backend Pool)
Use backend pool: nexus_docker_dev_backend
```

Добавляем Public Service (Settings/Virtual Services/Public Services)
```yml
name: infra
Listen Addresses: 10.240.240.33:443
Enable SSL offloading: true
Certificates: Добавляем сертификаты(ACME Client)
# HTTP(S) settings
X-Forwarded-For header: true
# Advanced settings
# Select Rules: Добавляем сюда правило из Settings/Rules&Checks/Rules
Select Rules: nexus_docker_dev_frontend
```

Не забываем нажимать `Apply`