k8s_config "cert-manager" {
  cluster = "k8s_cluster.${var.smi_controller_k8s_cluster}"

  paths = [
    "${file_dir()}/cert-manager.yaml",
  ]

  wait_until_ready = true

  health_check {
    timeout = "60s"
    pods    = ["app.kubernetes.io/instance=cert-manager"]
  }
}