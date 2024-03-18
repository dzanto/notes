---
title: "Rancher"
date: 2023-10-13T09:00:00+03:00
draft: false
tags: [rke2]
---

sudo journalctl -u rke2-agent.service -f

export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
/var/lib/rancher/rke2/bin/kubectl get nodes

cilium status --verbose
cilium-health status

nmcli con mod ens33 ethtool.feature-tx-udp_tnl-segmentation off ethtool.feature-tx-udp_tnl-csum-segmentation off

удаление

/usr/local/bin/rke2-uninstall.sh


Ошибка
> failed to create listener: failed to listen on 0.0.0.0:10258: listen tcp 0.0.0.0:10258: bind: address already in use


### Восстановление из бэкапа
Проверяем инструкцию: https://docs.rke2.io/backup_restore

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
