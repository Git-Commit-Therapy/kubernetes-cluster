apply: apply-custom-resource-definitions
    kubectl create secret tls ca-key-pair --cert=.keys/ca.crt --key=.keys/ca.key
    kubectl apply --recursive --filename .

create-ca:
    # Create a new CA certificate
    openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout .keys/ca.key -out .keys/ca.crt -subj "/C=IT/ST=Italy/L=Italy/CN=SanCommitto CA"
    chmod 600 .keys/ca.key

apply-custom-resource-definitions:
    kubectl apply --recursive --filename ./custom-resource-definitions

delete:
    kubectl delete --recursive --filename .
    kubectl delete secret ca-key-pair
