oc process -f postgresql-persistent.yaml \
    -p POSTGRESQL_USER=keycloak \
    -p POSTGRESQL_PASSWORD=keycloak \
    -p NAMESPACE=openshift \
    -p POSTGRESQL_DATABASE=keycloak \
| oc apply -f - -n ai-roadshow


oc process -f keycloak.yaml \
    -p KEYCLOAK_ADMIN=admin \
    -p KEYCLOAK_ADMIN_PASSWORD=admin \
    -p KEYCLOAK_DB_PASSWORD=keycloak \
    -p KEYCLOAK_DB_USERNAME=keycloak \
    -p NAMESPACE=keycloak \
| oc apply -f - -n ai-roadshow
