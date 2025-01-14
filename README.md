# Kubernetes cluster
## Deploying
### Authentication on GHC
The deployed images are private. You need to configure a secret object on the node in order to deploy applications, otherwise Kubernetes won't be able to pull images.

The following commands describe how to authenticate on the GHCR with Docker using a GitHub token and to use these credentials to authetnicate in Kubernetes.

⚠️ WARNING: Docker stores these credentials unencrypted in the file `~/.docker/config.json`. After you've created the secret, you can delete credentials from this file.

```sh
# Login on Docker
GH_USERNAME=<github_username>
GH_TOKEN=<access_token_github>
docker login ghcr.io --username $GH_USERNAME --password $GH_TOKEN

# Copy login credentials from local Docker configuration
# Copia login da Docker locale
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/$USER/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```
The commands above will create a secret named `regcred`, which is used by the deployments in this repo.

## Secrets
Change all secrets in the files inside the `/secrets` directory. Secrets have to be written in Base64 format.
The following example secrets are set:
- Postgres default username: `postgres`
- Postgres default password: `postgres`
- Keycloak admin username: `admin`
- Keycloak admin password: `admin`
- Self signed certificates and private key for keycloak HTTPS

## Deploying
Deploy with just:
```sh
just apply
```

Delete all deployments:
```sh
just delete
```
