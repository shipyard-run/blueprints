template "consul_values" {
  source = file(var.consul_helm_values)
  destination = "${var.consul_data_folder}/consul_values.yaml"

  vars = {
    datacenter = var.consul_datacenter
    tls_enabled = var.consul_tls_enabled
    acl_enabled = var.consul_acls_enabled
    federation_enabled = var.consul_federation_enabled
    create_federation_secret = var.consul_federation_create_secret
    gateway_enabled = var.consul_gateway_enabled
    gateway_address = var.consul_gateway_address
    consul_image = var.consul_image
    consul_k8s_image = var.consul_k8s_image
    consul_envoy_image = var.consul_envoy_image
  }
} 

//
// Install Consul using the helm chart.
//
helm "consul" {
  depends_on = ["template.consul_values"]
  cluster = "k8s_cluster.${var.consul_k8s_cluster}"

  chart = "github.com/hashicorp/consul-helm?ref=${var.consul_helm_version}"
  values = "${var.consul_data_folder}/consul_values.yaml"

  health_check {
    timeout = "120s"
    pods = ["app=consul"]
  }
}

template "fetch_consul_resources" {
  depends_on = ["helm.consul"]

  source = <<EOF
  #!/bin/sh -e

  echo "Port #{{ .Vars.port }}"
  echo "Fetching resources from running cluster, acls_enabled: #{{ .Vars.acl_enabled }}, tls_enabled #{{ .Vars.tls_enabled }}"

  #{{ if eq .Vars.acl_enabled "true" }}
  kubectl get secret -o jsonpath='{.data.token}' consul-bootstrap-acl-token | base64 -d > /data/bootstrap_acl.token
  #{{end}}
  
  #{{ if eq .Vars.tls_enabled "true" }}
  kubectl get secret -o jsonpath="{.data['tls\.crt']}" consul-ca-cert | base64 -d > /data/tls.crt
  kubectl get secret -o jsonpath="{.data['tls\.key']}" consul-ca-key | base64 -d > /data/tls.key
  #{{end}}
  EOF

  destination = "${var.consul_data_folder}/fetch.sh"

  vars = {
    port = var.consul_ports_api == 0 ? (var.consul_tls_enabled == true ? 8501 : 8500) : var.consul_ports_api
    tls_enabled = var.consul_tls_enabled
    acl_enabled = var.consul_acls_enabled
  }
}

# fetch acl tokens etc
exec_remote "fetch_consul_resources" {
  disabled = (var.consul_acls_enabled == false && var.consul_tls_enabled == false)

  depends_on = ["template.fetch_consul_resources"]

  image {
    name = "shipyardrun/tools:v0.5.0"
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
    source = k8s_config_docker(var.consul_k8s_cluster)
    destination = "/kubeconfig.yaml"
  }
  
  volume {
    source = var.consul_data_folder
    destination = "/data"
  }

  env {
    key = "KUBECONFIG"
    value = "/kubeconfig.yaml"
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
      address = "consul-server.default.svc"
      port = (var.consul_tls_enabled == true ? 8501 : 8500)
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
      address = "consul-server.default.svc"
      port = 8300
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
      address = "consul-server.default.svc"
      port = 8301
    }
  }
}

ingress "consul-gateway" {
  disabled = (var.consul_gateway_enabled == false)

  source {
    driver = "local"
    
    config {
      port = var.consul_ports_gateway
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-mesh-gateway.default.svc"
      port = 443
    }
  }
}
