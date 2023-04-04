# If this is a secondary datacenter in a federated cluster we need to add the CA and ACL 
# from the primary
template "bootstrap_certs_acls" {
  disabled = var.consul_ca_cert_file == "" && var.consul_acl_token_file == ""

  source = <<-EOF
  #{{ if eq .Vars.bootstrap_cert true }}
  kubectl create secret generic consul-ca-cert \
    --from-literal='tls_cert=#{{ file .Vars.ca_cert_file | trim }}' \
    -n ${var.consul_namespace}


  kubectl create secret generic consul-ca-key \
    --from-literal='tls_key=#{{ file .Vars.ca_key_file | trim }}' \
    -n ${var.consul_namespace}
  #{{ end }}
  
  #{{ if eq .Vars.bootstrap_acls true }}
  kubectl create secret generic consul-replication-token \
    --from-literal='replication.token=#{{ file .Vars.token_file | trim }}' \
    -n ${var.consul_namespace}
  #{{ end }}
  EOF


  destination = "${var.consul_data_folder}/bootstrap_certs_acls.sh"

  vars = {
    consul_namespace = var.consul_namespace
    bootstrap_cert   = var.consul_ca_cert_file == "" ? false : true
    bootstrap_acls   = var.consul_acl_token_file == "" || var.consul_acls_enabled == false ? false : true
    ca_cert_file     = var.consul_ca_cert_file
    ca_key_file      = var.consul_ca_key_file
    token_file       = var.consul_acl_token_file
  }
}

exec_remote "bootstrap_certs_acls" {
  disabled = var.consul_ca_cert_file == "" && var.consul_acl_token_file == ""

  depends_on = ["template.bootstrap_certs_acls", "k8s_cluster.${var.consul_k8s_cluster}"]

  image {
    name = "shipyardrun/tools:v0.7.0"
  }

  network {
    name = "network.${var.consul_k8s_network}"
  }

  cmd = "sh"
  args = [
    "/data/bootstrap_certs_acls.sh",
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

template "consul_values" {
  source      = file(var.consul_helm_values)
  destination = "${var.consul_data_folder}/consul_values.yaml"

  vars = {
    datacenter                  = var.consul_datacenter
    tls_enabled                 = var.consul_tls_enabled
    acl_enabled                 = var.consul_acls_enabled
    federation_enabled          = var.consul_federation_enabled
    create_federation_secret    = var.consul_federation_create_secret
    ingress_gateway_enabled     = var.consul_ingress_gateway_enabled
    ingress_gateway_ports       = var.consul_ports_ingress_gateway
    mesh_gateway_enabled        = var.consul_mesh_gateway_enabled
    mesh_gateway_address        = var.consul_mesh_gateway_address
    consul_image                = var.consul_image
    consul_k8s_image            = var.consul_k8s_image
    consul_envoy_image          = var.consul_envoy_image
    transparent_proxy_enabled   = var.consul_transparent_proxy_enabled
    auto_inject_enabled         = var.consul_auto_inject_enabled
    auto_inject_deny_namespaces = var.consul_auto_inject_deny_namespaces
    monitoring_namespace        = var.monitoring_namespace
    metrics_enabled             = var.consul_monitoring_enabled
    debug                       = var.consul_debug_enabled
    cert_secret_name            = var.consul_ca_cert_file != "" ? "consul-ca-cert" : ""
    cert_secret_key             = var.consul_ca_cert_file != "" ? "tls_cert" : ""
    key_secret_name             = var.consul_ca_cert_file != "" ? "consul-ca-key" : ""
    key_secret_key              = var.consul_ca_cert_file != "" ? "tls_key" : ""
    replication_token_name      = var.consul_acl_token_file != "" ? "consul-replication-token" : ""
    replication_token_key       = var.consul_acl_token_file != "" ? "replication.token" : ""
    primary_datacenter          = var.consul_primary_datacenter
    primary_gateway             = var.consul_primary_gateway
    k8s_api_server              = var.consul_primary_gateway != "" ? "https://${var.consul_mesh_gateway_address}:${cluster_port("k8s_cluster.${var.consul_k8s_cluster}")}" : ""
    debug                       = var.consul_debug_enabled
  }
}

//
// Install Consul using the helm chart.
//
helm "consul" {
  depends_on = ["template.consul_values", "k8s_config.consul_namespace", "exec_remote.bootstrap_certs_acls"]
  namespace  = var.consul_namespace
  cluster    = "k8s_cluster.${var.consul_k8s_cluster}"

  repository {
    name = "hashicorp"
    url  = "https://helm.releases.hashicorp.com"
  }

  chart   = "hashicorp/consul"
  version = var.consul_helm_version

  values = "${var.consul_data_folder}/consul_values.yaml"

  health_check {
    timeout = var.consul_health_check_timeout
    pods = [
      "component=webhook-cert-manager",
      "component=connect-injector",
      "component=server",
    ]
  }
}

template "fetch_consul_resources" {
  depends_on = ["helm.consul"]

  source = <<EOF
  #!/bin/sh -e

  echo "Port #{{ .Vars.port }}"
  echo "Fetching resources from running cluster, acls_enabled: #{{ .Vars.acl_enabled }}, tls_enabled #{{ .Vars.tls_enabled }}"

  #{{ if eq .Vars.acl_enabled true }}
  kubectl get secret -n #{{ .Vars.consul_namespace }} -o jsonpath='{.data.token}' consul-bootstrap-acl-token | base64 -d > /data/bootstrap_acl.token
  #{{end}}
  
  #{{ if eq .Vars.tls_enabled true }}
  kubectl get secret -n #{{ .Vars.consul_namespace }} -o jsonpath="{.data['tls\.crt']}" consul-ca-cert | base64 -d > /data/tls.crt
  kubectl get secret -n #{{ .Vars.consul_namespace }} -o jsonpath="{.data['tls\.key']}" consul-ca-key | base64 -d > /data/tls.key
  #{{end}}
  EOF

  destination = "${var.consul_data_folder}/fetch.sh"

  vars = {
    port             = var.consul_ports_api == 0 ? (var.consul_tls_enabled == true ? 8501 : 8500) : var.consul_ports_api
    tls_enabled      = var.consul_tls_enabled
    acl_enabled      = var.consul_acls_enabled
    consul_namespace = var.consul_namespace
  }
}

# fetch acl tokens etc
exec_remote "fetch_consul_resources" {
  disabled = (var.consul_acls_enabled == false && var.consul_tls_enabled == false)

  depends_on = ["template.fetch_consul_resources"]

  image {
    name = "shipyardrun/tools:v0.7.0"
  }

  network {
    name = "network.${var.consul_k8s_network}"
  }

  cmd = "sh"
  args = [
    "/data/fetch.sh",
  ]

  # Mount a volume containing the config
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

ingress "consul" {
  source {
    driver = "local"

    config {
      port = var.consul_ports_api == 0 ? (var.consul_tls_enabled == true ? 8501 : 8500) : var.consul_ports_api
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.${var.consul_namespace}.svc"
      port    = (var.consul_tls_enabled == true ? 8501 : 8500)
    }
  }
}

ingress "consul-rpc" {
  source {
    driver = "local"

    config {
      port = var.consul_ports_rpc
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.${var.consul_namespace}.svc"
      port    = 8300
    }
  }
}

ingress "consul-lan-serf" {
  source {
    driver = "local"

    config {
      port = var.consul_ports_lan
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.${var.consul_namespace}.svc"
      port    = 8301
    }
  }
}

ingress "consul-gateway" {
  disabled = (var.consul_mesh_gateway_enabled == false)

  source {
    driver = "local"

    config {
      port = var.consul_ports_mesh_gateway
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-mesh-gateway.${var.consul_namespace}.svc"
      port    = 443
    }
  }
}

ingress "consul-ingress-gateway-1" {
  disabled = (var.consul_ingress_gateway_enabled == false || len(var.consul_ports_ingress_gateway) == 0)

  source {
    driver = "local"

    config {
      port = var.consul_ports_ingress_gateway[0]
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-ingress-gateway.${var.consul_namespace}.svc"
      port    = var.consul_ports_ingress_gateway[0]
    }
  }
}

ingress "consul-ingress-gateway-2" {
  disabled = (var.consul_ingress_gateway_enabled == false || len(var.consul_ports_ingress_gateway) < 2)

  source {
    driver = "local"

    config {
      port = var.consul_ports_ingress_gateway[1]
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-ingress-gateway.${var.consul_namespace}.svc"
      port    = var.consul_ports_ingress_gateway[1]
    }
  }
}
