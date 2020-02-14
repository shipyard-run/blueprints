k8s_cluster "k8s" {
  driver  = "k3s" // default
  version = "v1.0.0"

  nodes = 1 // default

  network  {
    name = "network.local"
  }
}

k8s_config "dashboard" {
    cluster = "k8s_cluster.k8s"

    paths = [
        "./k8s_config/dashboard.yml"
    ]
  
    wait_until_ready = true
}

k8s_config "web-app" {
    depends_on = ["helm.consul"]
    cluster = "k8s_cluster.k8s"

    paths = [
        "./k8s_config/web.yml",
        "./k8s_config/api.yml"
    ]
  
    wait_until_ready = true
}