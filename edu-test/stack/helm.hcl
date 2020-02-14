helm "consul" {
  cluster = "k8s_cluster.k8s"
  chart = "./helm-charts/consul-helm-0.16.2"
  values = "./helm-charts/consul-values.yml"

  health_check {
    timeout = "60s"
    pods = ["release=consul"]
  }
}