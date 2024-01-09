---
title: "Persistent volumes"
date: 2023-07-05T12:08:00+03:00
draft: false
tags: [k8s]
---
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx1
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: test-volume
      mountPath: /test
  volumes:
    - name: test-volume
      persistentVolumeClaim:
        claimName: rwx-storage
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: rwx-storage
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: vsphere-csi-sc
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: rwo-storage
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: vsphere-csi-sc
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: rwx-storage
spec:
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 1Gi
  storageClassName: vsphere-csi-sc
  volumeMode: Filesystem
EOF

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  podManagementPolicy: OrderedReady
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  serviceName: nginx
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
        - image: registry.k8s.io/nginx-slim:0.8
          imagePullPolicy: IfNotPresent
          name: nginx
          ports:
            - containerPort: 80
              name: web
              protocol: TCP
          resources: {}
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          volumeMounts:
            - mountPath: /usr/share/nginx/html
              name: www
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
  updateStrategy:
    rollingUpdate:
      partition: 0
    type: RollingUpdate
  volumeClaimTemplates:
    - apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        creationTimestamp: null
        name: www
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 1Gi
        volumeMode: Filesystem
```
