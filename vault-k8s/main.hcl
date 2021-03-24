network "dc1" {
  subnet = "10.7.0.0/16"
}

variable "vault_k8s_cluster" {
  default = "dc1"
}

module "vault" {
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-vault" 
}

k8s_cluster "dc1" {
  driver = "k3s"
  network {
    name = "network.dc1"
  }
}

k8s_config "postgres" {
  cluster = "k8s_cluster.dc1"

  paths = [
    "./files/config/postgres.yml",
  ]

  wait_until_ready = false
}

ingress "web" {
  source {
    driver = "local"
    config {
      port = 9090
    }
  }

  destination {
    driver = "k8s"
    config {
      cluster = "k8s_cluster.dc1"
      address = "web.default.svc"
      port = 9090
    }
  }
}

ingress "postgres" {
  source {
    driver = "local"
    config {
      port = 15432
    }
  }

  destination {
    driver = "k8s"
    config {
      cluster = "k8s_cluster.dc1"
      address = "postgres.default.svc"
      port = 5432
    }
  }
}
