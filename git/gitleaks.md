---
title: "Сканирование git репозитория на наличие секретов"
date: 2023-05-29T18:02:00+03:00
draft: false
tags: [git]
categories: ["linux"]
---
Gitleaks позволяет сканировать git репозиторий на наличие секретов.

Если необходимо расширить дефолтный конфиг, создаем кастомный:
```toml
title = "Gitleaks custom"

[extend]
useDefault = true

[[rules]]
description = "database secrets"
id = "database-secrets"
regex = '''\bDB_[A-Z]+:.+'''

[rules.allowlist]
description = "database secrets ignore empty string"
regexTarget = "match"
regexes = [
  '''\bDB_[A-Z]+:\s*['"]{2}$''',
]

[[rules]]
description = "url string"
id = "url-string"
regex = '''jdbc:postgresql://.*my-dev\.ru'''
[rules.allowlist]
description = "url allow list"
regexTarget = "match"
regexes = [
  '''url: jdbc:postgresql://URL_PASTE_HERE''',
]

[[rules]]
description = "username string"
id = "username-string"
regex = '''(\s|^)\busername: \w+'''
[rules.allowlist]
description = "database secrets ignore empty string"
regexTarget = "match"
regexes = [
  '''username: sa''',
  '''username: USER_PASTE_HERE''',
  '''username: login''',
  '''username: values''',
  '''username: string''',
]

[[rules]]
description = "password string"
id = "password-string"
regex = '''(\s|^)\bpassword: \w+'''
[rules.allowlist]
description = "database secrets ignore empty string"
regexTarget = "match"
regexes = [
  '''password: sa''',
  '''password: PASSWORD_PASTE_HERE''',
  '''password: string''',
  '''password: true''',
  '''password: boolean''',
  '''password: managerCardInfo''',
  '''password: formData''',
  '''password: data''',
  '''password: values''',
]

[[rules]]
description = "keycloak secrets"
id = "keycloack-secrets"
regex = '''\bKEYCLOAK_ADMIN_[A-Z]+:.+'''

[rules.allowlist]
description = "keycloak secrets ignore empty string"
regexTarget = "match"
regexes = [
  '''\bKEYCLOAK_ADMIN_[A-Z]+:\s*['"]{2}$''',
]

[[rules]]
description = "rabbitmq secrets"
id = "rabbitmq-secrets"
regex = '''\b(RABBITMQ_PASSWORD|RABBITMQ_USER):.+'''

[rules.allowlist]
description = "rabbitmq secrets ignore empty string"
regexTarget = "match"
regexes = [
  '''\b(RABBITMQ_PASSWORD|RABBITMQ_USER):\s*['"]{2}$''',
]

[[rules]]
description = "const key"
id = "const-key"
regex = '''(\bconst \w+_KEY = ".+";)'''

[rules.allowlist]
description = "const key"
regexTarget = "match"
regexes = [
  '''(\bconst \w+_KEY = "\*\*\*REMOVED\*\*\*";)''',
]

[allowlist]
description = "global allow list"
paths = [
  '''\.scripts/https-server/certs/client-key\.pem''',
]
regexTarget = "match"
regexes = [
  '''16bdec13-246d-4b4f-a917-5d720c6aa9a2''',
  '''-----BEGIN PRIVATE KEY-----", "-----END PRIVATE KEY----'''
]
```

Запустить можно через docker:
```bash
GIT_GROUP=core
GROUP_FOLDER=/home/ashishlin/nl/$GIT_GROUP
GITLEAKS_DIR=$(pwd)
project=core-auth-gateway
rm -rf $GROUP_FOLDER/*

git clone /home/ashishlin/nl/$GIT_GROUP-base/$project $GROUP_FOLDER/$project
sudo docker run -v $GROUP_FOLDER/$project:/path -v $GITLEAKS_DIR:/config ghcr.io/gitleaks/gitleaks:latest \
    detect -v --source="/path" --config /config/custom-conf.toml

# запускаем filter-repo
cd $GROUP_FOLDER/$project
git filter-repo --replace-text $GITLEAKS_DIR/replace.txt

sudo docker run -v $GROUP_FOLDER/$project:/path -v $GITLEAKS_DIR:/config ghcr.io/gitleaks/gitleaks:latest \
    detect -v --source="/path" --config /config/custom-conf.toml
```
