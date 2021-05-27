module "monitoring" {
  depends_on = ["helm.consul"]
  disabled = var.consul_monitoring_enabled ? false : true
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-monitoring"
  //source = "../kubernetes-monitoring"
}

k8s_config "consul_defaults" {
  depends_on = ["helm.consul"]
  disabled = var.consul_monitoring_enabled ? false : true
  
  cluster = "k8s_cluster.${var.consul_k8s_cluster}"
  paths = [
    "${file_dir()}/config/proxy-defaults.yaml",
  ]

  wait_until_ready = false
}
