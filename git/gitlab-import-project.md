---
title: "Импорт проекта GitLab API"
date: 2023-06-01T14:33:00+03:00
draft: false
tags: [gitlab, git]
---
Перед запуском скрипта экспортирвоать env:
```bash
export GITLAB_URL="https://gitlab.dev.ru"
export GITLAB_PRIVATE_TOKEN="glpat-xxx"
export GITLAB_PROJECT_PATH=my-project
export GITLAB_NAMESPACE="my-group/folder"
GITLAB_EXPORT_FILE_PATH=2023-06-01_09-51-514_my-project_export.tar.gz
```

Скрипт:
```python
#!/usr/bin/env python3
import os
import requests

gitlabUrl               = os.environ.get('GITLAB_URL')
gitlabPrivateToken      = os.environ.get('GITLAB_PRIVATE_TOKEN')
gitlabProjectPath       = os.environ.get('GITLAB_PROJECT_PATH')
gitlabExportFilePath    = os.environ.get('GITLAB_EXPORT_FILE_PATH')
gitlabNamespace         = os.environ.get('GITLAB_NAMESPACE')

url =  gitlabUrl + '/api/v4/projects/import'
files = { "file": open(gitlabExportFilePath, "rb") }
data = {
    "path": gitlabProjectPath,
    "namespace": gitlabNamespace
}
headers = {'PRIVATE-TOKEN': gitlabPrivateToken}

response = requests.post(url, headers=headers, data=data, files=files)

print (response.content)
```
