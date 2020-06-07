k8s_cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.17.4-k3s1"

  nodes = 1 // default

  network {
    name = "network.cloud"
  }
}

k8s_config "postgres" {
  cluster = "k8s_cluster.k3s"

  paths = [
    "./files/config/postgres.yml",
  ]

  wait_until_ready = false
}