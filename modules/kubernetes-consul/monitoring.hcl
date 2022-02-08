module "monitoring" {
  depends_on = ["helm.consul"]
  disabled   = var.consul_monitoring_enabled == false
  source     = "github.com/shipyard-run/blueprints?ref=296b620ba7dfcf1ed0a29b84d04ff30fdcf81210/modules//kubernetes-monitoring"
  #source = "../kubernetes-monitoring"
}

template "consul_proxy_defaults" {
  source      = file("./config/proxy-defaults.yaml")
  destination = "${var.consul_data_folder}/proxy-defaults.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

k8s_config "consul_defaults" {
  depends_on = ["helm.consul", "template.consul_proxy_defaults"]
  disabled   = var.consul_monitoring_enabled == false

  cluster = "k8s_cluster.${var.consul_k8s_cluster}"
  paths = [
    "${var.consul_data_folder}/proxy-defaults.yaml"
  ]

  wait_until_ready = false
}