template "consul_values" {
  source = file(var.consul_helm_values)
  destination = "${data("helm")}/consul_values.hcl"

  vars = {
    tls_enabled = var.consul_enable_tls
    acl_enabled = var.consul_enable_acls
  }
} 

//
// Install Consul using the helm chart.
//
helm "consul" {
  depends_on = ["template.consul_values"]
  cluster = "k8s_cluster.${var.consul_k8s_cluster}"

  // chart = "github.com/hashicorp/consul-helm?ref=crd-controller-base"
  chart = "github.com/hashicorp/consul-helm?ref=v0.28.0"
  values = "${data("helm")}/consul_values.hcl"

  health_check {
    timeout = "120s"
    pods = ["app=consul"]
  }
}

ingress "consul" {
  source {
    driver = "local"
    
    config {
      port = var.consul_api_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.default.svc"
      port = var.consul_enable_tls ? 8501 : 8500
    }
  }
}

template "fetch_consul_resources" {
  depends_on = ["helm.consul"]
  source = <<EOF
  #!/bin/sh -e
  
  echo "Fetching resources from running cluster, acls_enabled: #{{ .Vars.acl_enabled }}, tls_enabled #{{ .Vars.tls_enabled }}"

  #{{ if eq .Vars.acl_enabled "true" }}
  kubectl get secret -o jsonpath='{.data.token}' consul-bootstrap-acl-token | base64 -d > /data/bootstrap_acl.token
  #{{end}}
  
  #{{ if eq .Vars.tls_enabled "true" }}
  kubectl get secret -o jsonpath="{.data['tls\.crt']}" consul-ca-cert | base64 -d > /data/tls.crt
  kubectl get secret -o jsonpath="{.data['tls\.key']}" consul-ca-key | base64 -d > /data/tls.key
  #{{end}}
  EOF

  destination = "${data("helm")}/fetch.sh"

  vars = {
    tls_enabled = var.consul_enable_tls
    acl_enabled = var.consul_enable_acls
  }
}


# fetch acl tokens etc
exec_remote "fetch_consul_resources" {
  depends_on = ["template.fetch_consul_resources"]

  image {
    name = "shipyardrun/tools:latest"
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
    source = data("helm")
    destination = "/data"
  }

  env {
    key = "KUBECONFIG"
    value = "/kubeconfig.yaml"
  }
}

ingress "consul-rpc" {
  source {
    driver = "local"
    
    config {
      port = var.consul_rpc_port
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
      port = var.consul_lan_port
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
