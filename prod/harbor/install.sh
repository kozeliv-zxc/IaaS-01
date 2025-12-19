helm repo add harbor https://helm.goharbor.io

helm repo update

helm install harbor \
    harbor/harbor \
    --version "1.18.1" \
    -f values.yaml
