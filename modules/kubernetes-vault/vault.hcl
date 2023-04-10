helm "vault" {
  cluster = "k8s_cluster.${var.vault_k8s_cluster}"

  repository {
    name = "hashicorp"
    url  = "https://helm.releases.hashicorp.com"
  }

  chart   = "hashicorp/vault"
  version = var.vault_helm_version

  values = "./helm/vault-values.yaml"

  health_check {
    timeout = "120s"
    pods    = ["app.kubernetes.io/name=vault", "app.kubernetes.io/name=vault-agent-injector"]
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
      port    = var.vault_api_port
    }
  }
}