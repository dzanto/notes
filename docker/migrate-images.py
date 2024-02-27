#!/usr/bin/python3
import requests
import subprocess
import os
import re
import time

# перед выполнением выполнить docker login в source и dest репозиторий
registryUrl    = os.environ.get('REGISTRY_URL', 'my-docker.nexus.int.my-dev.ru')
registryUser   = os.environ.get('REGISTRY_USER', 'admin')
registryPass   = os.environ.get('REGISTRY_PASS',)
destUrl        = os.environ.get('DEST_URL', 'harbor.apps.infra.int.example.ru/my-docker')

url = 'https://' + registryUrl + '/v2/_catalog'
print(url)
r = requests.get(url, auth=(registryUser, registryPass))
response = r.json()
repoList = response.get('repositories')
print(repoList)

if repoList != []:
    for repo in repoList:
        url = 'https://' + registryUrl + '/v2/' + repo + '/tags/list'
        r = requests.get(url, auth=(registryUser, registryPass))
        response = r.json()

        repoName = response.get('name')
        tags = response.get('tags')

        activeSignatures = []
        for tag in tags:
            # исключаем существующие подписи и latest теги
            if tag == 'latest':
                sourceTag = registryUrl + '/' + repoName + ':' + tag
                destTag   = destUrl + '/' + repoName + ':' + tag
                pullTagCommand = "docker pull " + sourceTag
                changeTagCommand = "docker tag " + sourceTag + " " + destTag
                pushTagCommand = "docker push " + destTag
                # subprocess.run(cosignCommand, shell=True)
                # print(sourceTag)
                # print(destTag)
                # print(pullTagCommand)
                subprocess.run(pullTagCommand, shell=True)
                # print(changeTagCommand)
                subprocess.run(changeTagCommand, shell=True)
                # print(pushTagCommand)
                subprocess.run(pushTagCommand, shell=True)
