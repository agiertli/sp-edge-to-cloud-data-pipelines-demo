export PASSWORD="pwd"
export SERVER="https://api.cluster-9lvpb.9lvpb.sandbox1647.opentlc.com:6443"

oc login -u admin -p $PASSWORD --server=$SERVER
oc project edge1

oc set image dc/shopper shopper=quay.io/agiertli/shopper-keycloak:1.0.16