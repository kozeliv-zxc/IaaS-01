helm install forgejo \
    oci://code.forgejo.org/forgejo-helm/forgejo \
    --version "15.0.3" \
    -f values.yaml