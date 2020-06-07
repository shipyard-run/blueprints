helm "vault" {
  cluster = "k8s_cluster.k3s"
  chart = "github.com/hashicorp/vault-helm?ref=v0.5.0"
  values = "./vault-values.yaml"

  health_check {
    timeout = "120s"
    pods = ["app.kubernetes.io/name=vault"]
  }
}