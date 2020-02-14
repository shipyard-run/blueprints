k8s_config "dashboard" {
  cluster = "k8s_cluster.k3s"

  paths = ["./k8s_config/"]
  wait_until_ready = false
}