

k8s_cluster "kubernetes" {
  depends_on = ["container.waypoint-odr"]
  driver     = "k3s"

  network {
    name = "network.cloud"
  }

  image {
    name = "shipyard.run/localcache/waypoint-odr:${var.waypoint_odr_tag}"
  }

  volume {
    source      = "./files/keys/registries.yaml"
    destination = "/etc/rancher/k3s/registries.yaml"
  }
}

output "KUBECONFIG" {
  value = k8s_config("kubernetes")
}