helm "consul" {
  cluster = "k8s_cluster.k3s"

  chart = "github.com/hashicorp/consul-helm?ref=v0.23.1"
  values = "./helm/consul-values.yaml"

  health_check {
    timeout = "60s"
    pods = ["release=consul"]
  }
}