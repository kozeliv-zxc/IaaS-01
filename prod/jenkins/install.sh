helm install jenkins \
  oci://ghcr.io/jenkinsci/helm-charts/jenkins \
  --version "5.8.114" \
  -f values.yaml


kubectl apply -f jenkin-dast.yaml