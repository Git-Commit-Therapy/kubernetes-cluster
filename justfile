apply:
    # First we apply custom resource definitions for Keycloak Operator
    kubectl apply --recursive --filename ./keycloak-operator
    # Then we apply all other resources
    kubectl apply --recursive --filename .

delete:
    kubectl delete --recursive --filename .
