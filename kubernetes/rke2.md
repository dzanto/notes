---
title: "Rancher"
date: 2023-10-13T09:00:00+03:00
draft: false
tags: [rke2]
---

sudo journalctl -u rke2-agent.service -f

journalctl -efu rancher-system-agent

export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/var/lib/rancher/rke2/bin
export CONTAINER_RUNTIME_ENDPOINT=unix:///run/k3s/containerd/containerd.sock
export IMAGE_SERVICE_ENDPOINT=unix:///run/k3s/containerd/containerd.sock

kubectl get nodes
crictl pods
crictl ps --all
crictl logs -f container_id
crictl inspect container_id1
crictl exec -it container_id sh
crictl images
crictl pull image:tag
crictl rmi --prune

cilium status --verbose
cilium-health status

nmcli con mod ens33 ethtool.feature-tx-udp_tnl-segmentation off ethtool.feature-tx-udp_tnl-csum-segmentation off

удаление

/usr/local/bin/rke2-uninstall.sh


Ошибка
> failed to create listener: failed to listen on 0.0.0.0:10258: listen tcp 0.0.0.0:10258: bind: address already in use


### Восстановление из бэкапа
Проверяем инструкцию: https://docs.rke2.io/backup_restore

Бэкапим:
- /var/lib/rancher/rke2/server/{cred,tls,token}
- /etc/rancher/rke2
- etcd bd snapshots
```sh
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="v1.27.11-rke2r1" sh -

cp -R rancher/rke2/* /etc/rancher/rke2/

rke2 server \
  --cluster-reset \
  --cluster-reset-restore-path=/root/15-06-2024-backup/snapshots/etcd-snapshot-rancher1.infra.int.nloto.ru-1718269204 \
  --token XXXXXXXXXXXXXXXX::server:xxxxxxxxxxxxxxxxxxx
```

На первой ноде после запуска rke2-server была ошибка:

> Error from server (InternalError): Internal error occurred: failed calling webhook "rancher.cattle.io.namespaces.create-non-kubesystem": failed to call webhook: Post "https://rancher-webhook.cattle-system.svc:443/v1/webhook/validation/namespaces?timeout=10s": no endpoints available for service "rancher-webhook"

Помогло удаление rancher-webhook сертификата, после чего rancher запустился, и можно было передобавлять оставшиеся ноды в кластер.
https://github.com/rancher/rancher/issues/35068#issuecomment-954457381
https://www.suse.com/support/kb/doc/?id=000020699

kubectl delete mutatingwebhookconfigurations rancher.cattle.io 
kubectl delete validatingwebhookconfigurations rancher.cattle.io
kubectl -n cattle-system delete service webhook-service

или

kubectl delete secret -n cattle-system cattle-webhook-tls
kubectl delete pod -n cattle-system -l app=rancher-webhook

### etcd
```sh
# заходим на мастер
crictl ps --all | grep etcd
crictl exec -it 83b39c733af50 bash

# список нод
etcdctl --cert /var/lib/rancher/rke2/server/tls/etcd/server-client.crt --key /var/lib/rancher/rke2/server/tls/etcd/server-client.key --endpoints https://127.0.0.1:2379 --cacert /var/lib/rancher/rke2/server/tls/etcd/server-ca.crt member list -w table

#удаляем ноду
etcdctl --cert /var/lib/rancher/rke2/server/tls/etcd/server-client.crt --key /var/lib/rancher/rke2/server/tls/etcd/server-client.key --endpoints https://127.0.0.1:2379 --cacert /var/lib/rancher/rke2/server/tls/etcd/server-ca.crt member remove <node-id from previous cmd>
```
