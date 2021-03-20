network "dc2" {
  subnet = "10.6.0.0/16"
}

k8s_cluster "dc2" {
  driver  = "k3s" // default
  version = "v1.0.1"

  nodes = 1 // default

  network {
    name = "network.dc2"
  }
  
  network {
    name = "network.wan"
  }
  
  image {
    name = "consul:1.8.0-rc1"
  }
}

k8s_config "dc2" {
  cluster = "k8s_cluster.dc2"
  paths = [
    "./k8s_config/gossip-secret.yaml",
  ]

  wait_until_ready = true
}

helm "dc2" {
  depends_on = ["k8s_config.dc2","exec_remote.configure"]
  cluster = "k8s_cluster.dc2"

  chart = "github.com/hashicorp/consul-helm?ref=v0.24.1"
  values = "./helm/consul-values.yaml"

  # We need to set values specifically for federation  
  values_string = {
    "meshGateway.wanAddress.static"          = "192.168.0.201"
    "global.datacenter" = "dc2"
    "global.tls.caCert.secretName"           = "consul-federation"
    "global.tls.caCert.secretKey"            = "caCert"
    "global.tls.caKey.secretName"            = "consul-federation"
    "global.tls.caKey.secretKey"             = "caKey"
    "global.acl.replicationToken.secretName" = "consul-federation"
    "global.acl.replicationToken.secretKey"  = "replicationToken"
    "server.extraVolumes[0].type"            = "secret"
    "server.extraVolumes[0].name"            = "consul-federation"
    "server.extraVolumes[0].load"            = "true"
    "server.extraVolumes[0].items[0].key"    = "serverConfigJSON"
    "server.extraVolumes[0].items[0].path"   = "config.json"
  }

  health_check {
    timeout = "120s"
    pods = ["app=consul"]
  }
}

k8s_ingress "consul-dc2" {
  cluster = "k8s_cluster.dc2"

  network {
    name = "network.dc2"
  }

  service  = "consul-ui"

  port {
    local  = 443
    remote = 443
    host   = 2443
  }
}

k8s_ingress "gateway-dc2" {
  cluster = "k8s_cluster.dc2"

  network {
    name = "network.dc2"
  }
  
  network {
    name = "network.wan"
    ip_address = "192.168.0.201"
  }

  service  = "consul-mesh-gateway"

  port {
    local  = 443
    remote = 443
  }
}