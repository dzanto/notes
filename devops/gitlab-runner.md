# Ограничение ресурсов для gitlab-runner в kubernetes

https://docs.gitlab.com/runner/executors/kubernetes.html

Основной конфиг выглядит так:
```conf
[runners.kubernetes]
    cpu_request = "2"
    cpu_limit = "2"
    cpu_limit_overwrite_max_allowed = "4"
    cpu_request_overwrite_max_allowed = "4"
    memory_limit = "2Gi" # стандартное значение для всех проектов
    memory_request = "2Gi"
    memory_request_overwrite_max_allowed = "6Gi"
    memory_limit_overwrite_max_allowed = "6Gi" # выше чем это значение мы не сможет указать в проекте.
    helper_memory_request = "384M"
    helper_memory_limit = "384M"
    service_cpu_request = "300m"
    service_memory_limit = "384Mi"
    service_memory_request = "384Mi"
    service_memory_request_overwrite_max_allowed = "2Gi"
    service_memory_limit_overwrite_max_allowed = "2Gi"
```

https://docs.gitlab.com/runner/executors/kubernetes.html#overwrite-container-resources

Для ограничения ресурсов для конкретного проекта, необходимо в .gitlab-ci.yml или настройках settings/ci_cd/variables добавить соотвествующие переменные. Например для основого (build) контейнера:

```yaml
KUBERNETES_MEMORY_REQUEST: "2Gi"
KUBERNETES_MEMORY_LIMIT: "4Gi"
```
