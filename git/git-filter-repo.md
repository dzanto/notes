# удаление файла из git репозитория
```sh
dnf install git-filter-repo
git filter-repo --invert-paths --path <path to the file or directory>
```

# Удаление секретов из git репозитория

Перед выполнением работ необходимо сделать бэкап проекта с помощью экспорта. В настройках GitLab проекта.
>Settings/General/Advanced/Export project

Клонируем репу в чистый каталог с опцией `--bare`
```
git clone --bare <git-project-url>
```

Создаем конфиг replace.txt для filter-repo:
```
regex:\bDB_URL: .+==>DB_URL: ''
regex:\${DB_URL:.+}==>${DB_URL}
regex:\bpassword: admin==>password: ""
mypassword
```

Запускаем git filter-repo:
```sh
git filter-repo --replace-text path-to/replace.txt
```

Если в репозитории есть protected_tags и protected_branches, снимаем с них protected и пушим:
```sh
git push origin --force 'refs/heads/*'
git push origin --force 'refs/tags/*'
git push origin --force 'refs/replace/*
```

После пуша, сработают pipline если они были настроены.

Востанавливаем protected_tags и protected_branches.

### Скрипт который все это делает автоматически
```python
#!/usr/bin/env python
import gitlab
import subprocess
import requests
import os

gitlabUrl = os.environ.get('GITLAB_URL')
gitlabPrivateToken = os.environ.get('GITLAB_PRIVATE_TOKEN')
projectId = 12
gitGroup = "core"
groupFolder = "/home/" + gitGroup
gitLeaksDir = "/home/gitleaks"
headers = {'PRIVATE-TOKEN': gitlabPrivateToken}

### клонируем репо
gl = gitlab.Gitlab(url=gitlabUrl, private_token=gitlabPrivateToken)
project = gl.projects.get(projectId)
print(project.name)
gitCloneCmd = "git clone --bare " + project.ssh_url_to_repo + " " + groupFolder + "/" + project.name + ".git"
subprocess.run(gitCloneCmd, shell=True)

# run git filter-repo
gitFilterCmd = "git filter-repo --replace-text " + gitLeaksDir + "/replace.txt"
currentWorkDir = groupFolder + "/" + project.name + ".git"
subprocess.run(gitFilterCmd, shell=True, cwd=currentWorkDir)

### get protected tags
url = gitlabUrl + '/api/v4/projects/' + str(project.id) + '/protected_tags'
print(url)
r = requests.get(url, headers=headers)
protectedTags = r.json()

### unprotect tags
if protectedTags != []:
    for protectedTag in protectedTags:
        url = gitlabUrl + '/api/v4/projects/' + str(project.id) + '/protected_tags/' + protectedTag['name']
        print(url)
        print(protectedTag['create_access_levels'][0]['access_level'])
        r = requests.delete(url, headers=headers)
else:
    print("No protected tags")

# allow_force_push = true
for protectedBranche in project.protectedbranches.list():
    url = gitlabUrl + '/api/v4/projects/' + str(project.id) + '/protected_branches/' + protectedBranche.name + '?allow_force_push=true'
    print(url)
    r = requests.patch(url, headers=headers)

# пушим изменения в гит
print("git push origin --force 'refs/heads/*'")
subprocess.run("git push origin --force 'refs/heads/*'", shell=True, cwd=currentWorkDir)
print("git push origin --force 'refs/tags/*'")
subprocess.run("git push origin --force 'refs/tags/*'", shell=True, cwd=currentWorkDir)
print("git push origin --force 'refs/replace/*'")
subprocess.run("git push origin --force 'refs/replace/*'", shell=True, cwd=currentWorkDir)

## protect tags
if protectedTags != []:
    for protectedTag in protectedTags:
        url = gitlabUrl + '/api/v4/projects/' + str(project.id) + '/protected_tags'
        data = {"create_access_level" : protectedTag['create_access_levels'][0]['access_level'], "name" : protectedTag['name']}
        print(url)
        print(data)
        r = requests.post(url, headers=headers, data=data)

# allow_force_push = false
for protectedBranche in project.protectedbranches.list():
    url = gitlabUrl + '/api/v4/projects/' + str(project.id) + '/protected_branches/' + protectedBranche.name + '?allow_force_push=false'
    print(url)
    r = requests.patch(url, headers=headers)
```
