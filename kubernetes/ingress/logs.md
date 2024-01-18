### Проверить логи ингрессов

```sh
for host in worker-{1..30}.k8s.exapmple.ru; do echo $host; ssh $host "sudo grep '<что ищем>' /var/log/containers/<имя-пода-ingress-контроллера>*"; done
```
