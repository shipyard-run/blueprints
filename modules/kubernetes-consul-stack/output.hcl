output "KUBECONFIG" {
  value = k8s_config("${var.consul_k8s_cluster}")
}
