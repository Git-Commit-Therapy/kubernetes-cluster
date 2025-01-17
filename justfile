apply: apply-custom-resource-definitions
    # kubectl create secret tls ca-key-pair --cert=.keys/ca.crt --key=.keys/ca.key
    kubectl apply --recursive --filename .

# Deprecated
create-ca:
    # Create a new CA certificate
    openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout .keys/ca.key -out .keys/ca.crt -subj "/C=IT/ST=Italy/L=Italy/CN=SanCommitto CA"
    chmod 600 .keys/ca.key

install-dependencies:
    helm repo add jetstack https://charts.jetstack.io --force-update
    helm install cert-manager jetstack/cert-manager \
      --namespace cert-manager \
      --create-namespace \
      --version v1.16.2 \
      --set crds.enabled=true
    # The option --set secretTargets.enabled=true is required to write the trust bundle to a secret
    # Vaffanculo Keycloak che non supporta le ConfigMap per i trust bundles
    helm upgrade trust-manager jetstack/trust-manager \
      --install \
      --namespace cert-manager \
      --wait \
      --set secretTargets.enabled=true \
      --set secretTargets.authorizedSecretsAll=true # This is can be dangerous, but it took me two days, without it it doesn't work

apply-custom-resource-definitions:
    kubectl apply --recursive --filename ./custom-resource-definitions

delete:
    kubectl delete --recursive --filename .
    # kubectl delete secret ca-key-pair

delete-dependencies:
    helm uninstall cert-manager --namespace cert-manager
    helm uninstall trust-manager --namespace cert-manager
    # Clean CRS left by cert-manager
    kubectl delete crd \
      issuers.cert-manager.io \
      clusterissuers.cert-manager.io \
      certificates.cert-manager.io \
      certificaterequests.cert-manager.io \
      orders.acme.cert-manager.io \
      challenges.acme.cert-manager.io

    # Clean CRS left by trust-manager
    kubectl delete crd bundles.trust.cert-manager.io
