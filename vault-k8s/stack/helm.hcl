helm "vault" {
  cluster = "cluster.k3s"
  chart = "./helm/vault-helm-0.3.0"
  values = "./helm/vault-values.yaml"

  health_check {
    timeout = "30s"
    pods = ["app.kubernetes.io/name=vault"]
  }
}