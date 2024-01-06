# Как залогиниться в argocd cli

Информация взята из issue: https://github.com/argoproj/argo-cd/issues/4424

### kubeconfig
ArgoCD cli может получить доступ к серверу через kubeconfig. Для этого еобходимо сменить контекст kubectl. И использовать флаг `--core`
```sh
kubectl config set-context --current --namespace=argocd
argocd login argocd.example.com --core
```

### keycloak
Если используется keycloak. Получить ACCESS_TOKEN через REST API keycloak
```sh
export ACCESS_TOKEN=$(curl -s -X POST -H 'Accept: application/json' -H 'Content-Type: application/x-www-form-urlencoded' -d "username=${USER}" -d "password=${PASSWORD}" -d 'grant_type=password' -d "client_id=${ARGOCD_CLIENT}" -d 'scope=offline_access' -d "client_secret=${CLIENT_SECRET}" ${KEYCLOAK_REALM}/protocol/openid-connect/token | jq -r .access_token)
```
и использовать его при выполнении каждой команды
```sh
argocd app list --auth-token $ACCESS_TOKEN --server argocd.example.com
```
