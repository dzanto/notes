---
title: "Rancher"
date: 2023-10-13T09:00:00+03:00
draft: false
tags: [rke2]
---
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
/var/lib/rancher/rke2/bin/kubectl get nodes

cilium status --verbose
cilium-health status

nmcli con mod ens33 ethtool.feature-tx-udp_tnl-segmentation off ethtool.feature-tx-udp_tnl-csum-segmentation off