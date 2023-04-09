exec_local "clone_efk" {
  cmd = "./modules/kubernetes-efk-stack/run.sh"
  timeout = "420s"
  env {
    key = "KUBECONFIG"
    value = k8s_config("dc1")
  }
  daemon = true 
  #Preferred not to be in daemon but couldn't stop the shell script run
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