exec_remote "install_istio" {
  depends_on = ["k8s_cluster.${var.istio_k8s_cluster}"]

  image {
    name = "shipyardrun/istio-tools:v1.10.2"
  }

  cmd = "istioctl"
  args = ["install","-y"]

  volume {
    source = k8s_config_docker(var.istio_k8s_cluster)
    destination = "/.kube/config"
  }

  env {
    key = "KUBECONFIG"
    value = "/.kube/config"
  }

  network {
    name = "network.${var.istio_k8s_network}"
  }
}