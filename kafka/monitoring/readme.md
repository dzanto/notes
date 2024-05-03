https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/kafka-metrics.yaml
https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/grafana-dashboards/strimzi-kafka.json

https://strimzi.io/docs/operators/latest/configuring.html#con-common-configuration-prometheus-reference
https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/kafka-metrics.yaml

# metricsConfig:
#   type: jmxPrometheusExporter
#   valueFrom:
#     configMapKeyRef:
#       name: kafka-metrics
#       key: kafka-metrics-config.yml
