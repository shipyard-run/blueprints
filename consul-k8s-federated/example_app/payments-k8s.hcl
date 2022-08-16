k8s_config "payments" {
  depends_on = ["module.kubernetes_consul"]

  cluster = "k8s_cluster.kubernetes"
  paths = [
    "./k8s_files/payments.yaml",
  ]

  wait_until_ready = true
}
