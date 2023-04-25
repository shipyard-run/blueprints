exec_remote "clone_efk" {

  image {
    name = "shipyardrun/tools"
  } 
  cmd = "./efk/run.sh"

  volume {
    source = k8s_config_docker(var.efk_k8s_cluster)
    destination = "/.kube/config"
  }

  volume {
    source      = var.efk_folder
    destination = "/efk/run.sh"
  }

  network {
    name = "network.${var.efk_k8s_network}"
  }

  env {
    key = "KUBECONFIG"
    value = "/.kube/config"
  }
}

ingress "efk" {
  source {
    driver = "local"
    
    config {
      port = var.kibana_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.efk_k8s_cluster}"
      address = "efk-stack-kibana-kb-http.${var.namespace}.svc"
      port = var.kibana_port
    }
  }
}