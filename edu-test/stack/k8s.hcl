cluster "k8s" {
  driver  = "k3s" // default
  version = "v1.0.0"

  nodes = 1 // default

  network = "network.local"
}

k8s_config "dashboard" {
    cluster = "cluster.k8s"
    paths = [
        "./k8s_config/dashboard.yml"
    ]
  
    wait_until_ready = true
}

k8s_config "web-app" {
    cluster = "cluster.k8s"
    paths = [
        "./k8s_config/web.yml"
        "./k8s_config/api.yml"
    ]
  
    wait_until_ready = true
}