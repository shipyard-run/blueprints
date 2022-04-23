template "release_controller_values" {
  disabled = !var.consul_release_controller_enabled

  source = <<EOF
autoencrypt:
  enabled: #{{ .Vars.tls_enabled }}
acls:
  enabled: #{{ .Vars.acls_enabled }}
EOF

  destination = "${var.consul_data_folder}/consul_release_values.yaml"

  vars = {
    acls_enabled = var.consul_acls_enabled
    tls_enabled  = var.consul_tls_enabled
  }
}

helm "release-controller" {
  disabled = !var.consul_release_controller_enabled

  depends_on = ["helm.consul", "template.release_controller_values"]
  namespace  = var.consul_namespace
  cluster    = "k8s_cluster.${var.consul_k8s_cluster}"

  repository {
    name = "release-controller"
    url  = "https://nicholasjackson.io/consul-release-controller"
  }

  chart   = "release-controller/consul-release-controller"
  version = var.consul_release_controller_helm_version

  values = "${var.consul_data_folder}/consul_release_values.yaml"
}