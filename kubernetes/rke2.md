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
