#!/usr/bin/python3
# перенос helm чартов из nexus в harbor
import requests
import subprocess
import os
import urllib.request

# перед выполнением выполнить helm registry login harbor.example.ru/my-helm
repoUrl    = os.environ.get('REPO_URL', 'nexus.example.ru')
repoUser   = os.environ.get('REPO_USER', 'admin')
repoPass   = os.environ.get('REPO_PASS', 'my-nexus-password')
destUrl    = os.environ.get('DEST_URL', 'harbor.example.ru/my-helm')

continuationToken = ''

while continuationToken != None:
    if continuationToken == '':
        url = 'https://' + repoUrl + '/service/rest/v1/components?repository=my-helm-dev'
    else:
        url = 'https://' + repoUrl + '/service/rest/v1/components?repository=my-helm-dev&continuationToken=' + continuationToken

    r = requests.get(url, auth=(repoUser, repoPass))
    response = r.json()
    continuationToken = response['continuationToken']

    for chart in response['items']:
        # name        = chart['name']
        # version     = chart['version']
        downloadUrl = chart['assets'][0]['downloadUrl']
        path        = chart['assets'][0]['path']

        print(path)
        urllib.request.urlretrieve(downloadUrl, path)

        helmPushCommand = 'helm push ' + path + ' oci://' + destUrl
        subprocess.run(helmPushCommand, shell=True)
