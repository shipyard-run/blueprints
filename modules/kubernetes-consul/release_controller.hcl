template "release_controller_values" {
  disabled = !var.consul_release_controller_enabled

  source = <<EOF
fullnameOverride: "consul-release-controller"
autoencrypt:
  enabled: #{{ .Vars.tls_enabled }}
acls:
  enabled: #{{ .Vars.acls_enabled }}
webhook:
  failurePolicy: Ignore
EOF

  destination = "${var.consul_data_folder}/consul_release_values.yaml"

  vars = {
    acls_enabled = var.consul_acls_enabled
    tls_enabled  = var.consul_tls_enabled
  }
}

helm "cert_manager" {
  disabled = !var.consul_release_controller_enabled

  depends_on       = ["helm.consul"]
  cluster          = "k8s_cluster.${var.consul_k8s_cluster}"
  namespace        = "cert-manager"
  create_namespace = true

  repository {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
  }

  chart   = "jetstack/cert-manager"
  version = "v1.8.0"

  health_check {
    timeout = "120s"
    pods = [
      "app=cert-manager",
    ]
  }

  values_string = {
    "installCRDs" = true
  }
}

helm "release_controller" {
  disabled = !var.consul_release_controller_enabled

  depends_on = ["template.release_controller_values", "helm.cert_manager"]
  namespace  = var.consul_namespace
  cluster    = "k8s_cluster.${var.consul_k8s_cluster}"

  repository {
    name = "release-controller"
    url  = "https://nicholasjackson.io/consul-release-controller"
  }

  chart   = "release-controller/consul-release-controller"
  version = var.consul_release_controller_helm_version

  values = "${var.consul_data_folder}/consul_release_values.yaml"

  health_check {
    timeout = "120s"
    pods = [
      "app.kubernetes.io/instance=release-controller",
    ]
  }
}

ingress "consul_release_controller" {
  disabled = !var.consul_release_controller_enabled

  source {
    driver = "local"

    config {
      port = var.consul_ports_release_controller
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-release-controller.${var.consul_namespace}.svc"
      port    = 9443
    }
  }
}