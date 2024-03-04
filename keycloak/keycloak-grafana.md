### keycloak
Создаем клиент grafana-dev

Создаем роли в клиенте (соответствует role_attribute_path в настройках grafana)
- grafana-admins
- grafana-editors

В clientScopes/grafana-dev-dedicated


Mapper type: User Client Role
Name: client roles
Client ID: grafana-dev
Client Role prefix:
Multivalued: On
Token Claim Name: groups (соответствует role_attribute_path в настройках grafana)
Claim JSON Type: String
Add to ID token: On
Add to access token: On
Add to userinfo: Off
Add to token introspection: On

### Grafana
```yaml
  grafana.ini:
    auth:
      disable_login_form: true
    auth.anonymous:
      enabled: true
      org_role: Viewer
    auth.basic:
      enabled: false
    dashboards:
      default_home_dashboard_path: /tmp/dashboards/rancher-default-home.json
    security:
      allow_embedding: true
    users:
      auto_assign_org_role: Viewer
    auth.generic_oauth:
      allow_sign_up: true
      api_url: >-
        https://keycloak.infra.example.ru/realms/nl/protocol/openid-connect/userinfo
      auth_url: >-
        https://keycloak.infra.example.ru/realms/nl/protocol/openid-connect/auth
      client_id: grafana-dev
      client_secret: xxxxxxxxxxxx
      email_attribute_name: email:primary
      empty_scopes: false
      enabled: true
      icon: signin
      login_attribute_path: preferred_username
      name: Keycloak
      role_attribute_path: >-
        contains(groups[*], 'grafana-admins') && 'Admin' || contains(groups[*],
        'grafana-editors') && 'Editor' || 'Viewer'
      role_attribute_strict: false
      scopes: openid profile email groups
      tls_skip_verify_insecure: false
      token_url: >-
        https://keycloak.infra.example.ru/realms/nl/protocol/openid-connect/token
    server:
      root_url: https://grafana.apps.dev.example.ru
```
