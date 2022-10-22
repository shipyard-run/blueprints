template "bootstrap_releaser_acls" {
  disabled   = var.consul_releaser_acl_token_file == ""
  depends_on = ["exec_remote.fetch_consul_resources"]

  source = <<-EOF
  kubectl create secret generic consul-releaser-token \
    --from-literal='token=#{{ file .Vars.token_file | trim }}' \
    -n #{{ .Vars.consul_namespace }}
  EOF

  destination = "${var.consul_data_folder}/bootstrap_releaser_acls.sh"

  vars = {
    consul_namespace = var.consul_namespace
    token_file       = var.consul_releaser_acl_token_file
  }
}

exec_remote "bootstrap_releaser_acls" {
  disabled = var.consul_releaser_acl_token_file == ""

  depends_on = ["template.bootstrap_releaser_acls", "exec_remote.fetch_consul_resources"]

  image {
    name = "shipyardrun/tools:v0.7.0"
  }

  network {
    name = "network.${var.consul_k8s_network}"
  }

  cmd = "sh"
  args = [
    "/data/bootstrap_releaser_acls.sh",
  ]

  # Mount a volume containing the config for the kube cluster
  volume {
    source      = "${shipyard()}/config/${var.consul_k8s_cluster}"
    destination = "/config"
  }

  volume {
    source      = var.consul_data_folder
    destination = "/data"
  }

  env {
    key   = "KUBECONFIG"
    value = "/config/kubeconfig-docker.yaml"
  }
}

template "release_controller_values" {
  disabled = var.consul_release_controller_enabled == false

  source = <<EOF
fullnameOverride: "consul-release-controller"
autoencrypt:
  enabled: #{{ .Vars.tls_enabled }}
acls:
  enabled: "false"
  #{{ if eq .Vars.bootstrap_acls true }}
  secretName: "consul-releaser-token"
  secretKey: "token"
  #{{ end }}
webhook:
  failurePolicy: Ignore
EOF

  destination = "${var.consul_data_folder}/consul_release_values.yaml"

  vars = {
    bootstrap_acls = var.consul_releaser_acl_token_file != ""
    tls_enabled    = var.consul_tls_enabled
  }
}

template "cert_manager_values" {
  disabled = var.consul_release_controller_enabled == false

  source = <<-EOF
  installCRDs: 'true'
  # Disable Transparent proxy and Consul injection
  startupapicheck:
    podAnnotations:
      'consul.hashicorp.com/connect-inject': 'false'
      'consul.hashicorp.com/transparent-proxy': 'false'
  cainjector:
    podAnnotations:
      'consul.hashicorp.com/connect-inject': 'false'
      'consul.hashicorp.com/transparent-proxy': 'false'
  webhook:
    podAnnotations:
      'consul.hashicorp.com/connect-inject': 'false'
      'consul.hashicorp.com/transparent-proxy': 'false'
  podAnnotations:
    'consul.hashicorp.com/connect-inject': 'false'
    'consul.hashicorp.com/transparent-proxy': 'false'
  EOF

  destination = "${var.consul_data_folder}/cert_manager_values.yaml"
}

helm "cert_manager" {
  disabled   = var.consul_release_controller_enabled == false
  depends_on = ["template.cert_manager_values", "helm.consul"]

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

  values = "${var.consul_data_folder}/cert_manager_values.yaml"
}

helm "release_controller" {
  disabled = var.consul_release_controller_enabled == false

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
  disabled = var.consul_release_controller_enabled == false

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
