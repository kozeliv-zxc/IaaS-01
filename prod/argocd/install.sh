helm install argocd \
  oci://ghcr.io/argoproj/argo-helm/argo-cd \
  --version "9.2.2" \
  -f values.yaml