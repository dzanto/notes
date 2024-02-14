# https://github.com/mikefarah/yq
# Скрипт для экспорта argocd applications из k8s. Лучше выполнять последовательно вручную.
# Экспортируем переменные
export ARGO_SOURCE_PROJECT=my-dev
export ARGO_DEST_PROJECT=mynew
export ARGO_SOURCE_CONTEXT=argocd.apps.dev.int.my-dev.ru
export KUBE_SOURCE_CONTEXT=dev
export KUBE_DEST_CONTEXT=dev-new
export NAMESPACE_DEST=mynew

# Проверяем что используем нужный контекст kubeconfig
kubectl config use-context $KUBE_SOURCE_CONTEXT

# Логинимся в argocd. Можно admin пользователем - пароль берем в кубере из argocd-initial-admin-secret
ARGO_ADMIN_PASS=$(kubectl get secrets -n argocd argocd-initial-admin-secret -o template --template={{.data.password}} | base64 --decode)
argocd login $ARGO_SOURCE_CONTEXT --username admin --password $ARGO_ADMIN_PASS --grpc-web

# Проверяем что используем нужный контекст argocd
argocd context $ARGO_SOURCE_CONTEXT

# Получаем имена applications из необходимого project и сохраняем манифесты applications.
APP_LIST=$(argocd app list -p $ARGO_SOURCE_PROJECT -o name --grpc-web | awk -F"/" '{print $2}')
for app in $APP_LIST; do
    kubectl get Applications $app -o yaml > $app.yaml; echo $app
done

# Удаляем лишнее и правим параметры для нового кластера.
for yaml in ./*; do
    yq -i 'del(.metadata.managedFields, .metadata.creationTimestamp, .metadata.generation, .metadata.resourceVersion, .metadata.uid, .status)' $yaml;
    yq -i eval '.spec.destination.namespace = env(NAMESPACE_DEST), .spec.project = env(ARGO_DEST_PROJECT)' $yaml;
    yq -i eval '.metadata.name = .spec.source.chart' $yaml; 
done

# Меняем urls
sed -i s/postgres1.dev.int.my-dev.ru:5432,postgres2.dev.int.my-dev.ru:5432/dev.int.mynew.ru:5432/g *
sed -i s/postgres1.dev.int.my-dev.ru:5432/dev.int.mynew.ru:5432/g *
sed -i s/dev.int.my-dev.ru:5432/dev.int.mynew.ru:5432/g *
sed -i s/-exapmle-dev.apps.dev.int.my-dev.ru/.apps.dev.int.mynew.ru/g *
sed -i s/-dev.apps.dev.int.my-dev.ru/.apps.dev.int.mynew.ru/g *
sed -i s/my-docker.nexus.int.my-dev.ru/my-docker-proxy.infra.int.mynew.ru/g *
sed -i s/minio.int.my-dev.ru/minio.infra.int.mynew.ru/g *
sed -i s/apps.dev.int.my-dev.ru/apps.dev.int.mynew.ru/g *

apps.dev.int.my-dev.ru

# Теперь меняем контекст в kubeconfig
kubectl config use-context $KUBE_DEST_CONTEXT
# И пушим манифесты
kubectl apply -f ./
