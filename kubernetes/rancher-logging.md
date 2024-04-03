fluentd не пишет логи в stdout. логи лежат в контейнере в /fluentd/log/out
```sh
kubectl exec rancher-logging-root-fluentd-0 -n cattle-logging-system -- cat /fluentd/log/out
```

https://habr.com/ru/articles/675728/
https://docs.fluentbit.io/manual/administration/buffering-and-storage
https://docs.fluentbit.io/manual/pipeline/inputs/tail
https://kube-logging.dev/docs/operation/troubleshooting/fluentbit/
https://kube-logging.dev/docs/logging-infrastructure/logging/
https://kube-logging.dev/4.0/docs/configuration/crds/v1beta1/fluentbit_types/



```yaml
apiVersion: logging.banzaicloud.io/v1beta1
kind: Logging
metadata:
  name: rancher-logging-root
spec:
  controlNamespace: cattle-logging-system
  fluentbit:
    image:
      repository: docker-io-proxy.infra.int.nloto.ru/rancher/mirrored-fluent-fluent-bit
      tag: 2.2.0 # для дебага(с утилитами) 2.2.0-debug
    inputTail:
      Exclude_Path: /var/log/containers/rancher-logging*.log # добавляем если используем logLevel: debug, иначе сам себя заспамит
      Mem_Buf_Limit: 32MB 
    logLevel: info # можно включить debug
  fluentd:
    configReloaderImage:
      repository: >-
        docker-io-proxy.infra.int.nloto.ru/rancher/mirrored-jimmidyson-configmap-reload
      tag: v0.4.0
    disablePvc: true
    image:
      repository: docker-io-proxy.infra.int.nloto.ru/rancher/mirrored-banzaicloud-fluentd
      tag: v1.14.6-alpine-5
    logLevel: info # можно включить debug. логи смотрим в /fluentd/log/out
    resources:
      limits:
        memory: 1024M
      requests:
        cpu: 1
        memory: 1024M
    scaling:
      replicas: 3
  watchNamespaces:
    - my-load
```


## Fluentd
```yaml
apiVersion: logging.banzaicloud.io/v1beta1
kind: Output
metadata:
  name: soc-syslog-output
  namespace: keycloak
spec:
  syslog:
    # https://kube-logging.dev/docs/configuration/plugins/outputs/buffer/
    # https://docs.fluentd.org/configuration/buffer-section
    buffer:
      flush_at_shutdown: true
      flush_mode: default
      flush_thread_count: 2
      retry_forever: false
      timekey: 600s
      timekey_wait: 0s
      total_limit_size: 3G
    format:
      app_name_field: kubernetes.pod_name
      hostname_field: keycloak
      rfc6587_message_size: false
    host: 192.168.10.100
    insecure: true
    port: 514
    transport: udp
```
