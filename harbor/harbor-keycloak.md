# harbor
Administration -> Configuration -> Authentication

auth_mode: oidc_auth
oidc_name: keycloak
oidc_endpoint: https://<keycloak_url>/realms/<realm-name>
oidc_client_id: harbor
oidc_client_secret: <keycloak-client-harbor-secret>
oidc_groups_claim: roles
oidc_admin_group: admin
oidc_scope: offline_access,openid,profile,email,roles
verify_certificate: true
oidc_auto_onboard: true
oidc_user_claim: username

# keycloak
### Clients -> Client details -> Roles

Добавляем role

Role name: admin (соответствует oidc_admin_group в harbor)

### Clients -> Client details -> Client scopes -> harbor-dedicated

Добавляем mapper:
```yml
- Mapper type: User Property
  Name: username
  Property: username
  Token Claim Name: username (соответствует oidc_user_claim в harbor)

- Mapper type: User Client Role
  Name: client roles
  Client ID: harbor
  Token Claim Name: roles (соответствует oidc_groups_claim в harbor)
```
