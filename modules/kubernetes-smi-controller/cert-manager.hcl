k8s_config "cert-manager" {
  cluster = "k8s_cluster.${var.smi_controller_k8s_cluster}"
  
  paths = [
    "${file_dir()}/cert-manager.crds.yaml",
  ]

  wait_until_ready = true
}

helm "cert-manager" {
  depends_on = ["k8s_config.cert-manager"]

  create_namespace = true
  namespace = "smi"
  cluster = "k8s_cluster.${var.smi_controller_k8s_cluster}"

  chart = "github.com/jetstack/cert-manager?ref=v1.1.0/deploy/charts//cert-manager"

  values = "${file_dir()}/helm/cert-manager-helm-values.yaml" 
 
  health_check {
    timeout = "60s"
    pods = ["app.kubernetes.io/instance=cert-manager"]
  }
}