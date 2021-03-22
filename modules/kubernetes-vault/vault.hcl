helm "vault" {
  cluster = "k8s_cluster.${var.vault_k8s_cluster}"
  chart = "github.com/hashicorp/vault-helm?ref=v0.9.1"
  values = "./helm/vault-values.yaml"

  health_check {
    timeout = "120s"
    pods = ["app.kubernetes.io/name=vault"]
  }
}

ingress "vault" {
  source {
    driver = "local"
    
    config {
      port = var.vault_api_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.vault_k8s_cluster}"
      address = "vault-ui.default.svc"
      port = 8200
    }
  }
}