# Обновление sonar

Берем за основу инструкцию: https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/upgrade-the-server/upgrade-guide/

Смотрим, что бы на диске с БД было 50% свободного места

Делаем бэкап БД
```sh
pg_dump sonar > ~/sonar-2023-07-10.sql
```
Если нужно будет восстановиться: `psql sonar < ~/sonar-2023-07-10.sql`

Ищем чарт для последней версии
```sh
helm search repo -l "sonarqube"

NAME             	CHART VERSION	APP VERSION                                     
bitnami/sonarqube	2.1.6        	9.9.0
```

Обновляем тег в моем случае в ArgoCD infra/apps/templates/sonar.yaml c "2.0.7" на 2.1.6

Переходим по адресу http://yourSonarQubeServerURL/setup и следуем инструкциям

4. Reanalyze your projects to get fresh data.

PostgreSQL clean-up https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/upgrade-the-server/upgrade-guide/#postgresql-cleanup
