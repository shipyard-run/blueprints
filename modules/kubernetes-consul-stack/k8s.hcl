//
// Create a single node Kubernetes cluster.
//
k8s_cluster "dc1" {
  driver  = "k3s"
  version = "v1.18.16"

  nodes = 1

  network {
    name = "network.${var.consul_kubernetes_network}"
  }
}

