module "monitoring" {
  depends_on = ["module.consul"]
  disabled = var.consul_enable_monitoring ? false : true
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-monitoring"
  #source = "${file_dir()}/../../../modules/kubernetes/monitoring"
}

//k8s_config "prometheus-setup" {
//  depends_on = ["module.monitoring"]
//
//  cluster = "k8s_cluster.dc1"
//  paths = [
//    "${file_dir()}/../setup/prometheus-config.yaml",
//  ]
//
//  wait_until_ready = true
//}
