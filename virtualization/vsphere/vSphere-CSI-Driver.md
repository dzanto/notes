# vSphere CSI Driver
Созданные PV находятся в разделе `Monitor/Cloud Native Storage/Container Volumes` соответствующего vCenter, Datacenter или Cluster


```yaml
apiVersion: v1
kind: Secret
metadata:
  name: vsphere-config-secret
  namespace: kube-system
stringData:
 csi-vsphere.conf: |
  [Global]
  cluster-id = "vSAN-DEV"
  user = "my_user@vcs.local"
  password = "my_password"
  port = "443"
  insecure-flag = "true"

  [VirtualCenter "vcs.dl-2.my.local"]
  datacenters = "DataLine-2"
```

```yaml
apiVersion: v1
data:
  vsphere.yaml: >
    # Global properties in this section will be used for all specified vCenters
    unless overriden in VirtualCenter section.

    global:
      secretName: "vsphere-cpi-creds"
      secretNamespace: "kube-system"
      port: 443
      insecureFlag: true

    # vcenter section

    vcenter:
      "vcs.dl-2.my.local":
        server: "vcs.dl-2.my.local"
        datacenters:
          - "DataLine-2"
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: vsphere-cpi
    meta.helm.sh/release-namespace: kube-system
  creationTimestamp: '2023-12-06T07:58:03Z'
  labels:
    app.kubernetes.io/managed-by: Helm
    component: rancher-vsphere-cpi-cloud-controller-manager
    vsphere-cpi-infra: config
  name: vsphere-cloud-config
  namespace: kube-system
```
