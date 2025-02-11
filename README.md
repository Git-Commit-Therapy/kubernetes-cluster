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

## Credentials

Change all credentials in values.yaml for Postgres and Keycloak.

## Deploying
The app is deployed through Helm and Helmfile. Install both of them.

On Arch Linux:
```sh
sudo pacman -S helm helmfile
```
Then initialize helmfile:
```sh
helmfile init
```

Finally, deploy the app:
```sh
helmfile apply
```

## Updating
Once deployed, if the cluster is modified, it can be updated the deployment using the following command:
```sh
helmfile sync
```

## Deleting
```sh
helmfile destroy
```
