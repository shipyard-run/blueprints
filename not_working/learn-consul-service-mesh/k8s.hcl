k8s_cluster "k8s" {
  driver  = "k3s" // default
  version = "v1.0.0"

  nodes = 1 // default

  network  {
    name = "network.local"
  }

  ## Using the image block the images defined will be cached for the next Sypyard deploy.

  image {
    name = "coredns/coredns:1.6.3"
  }
  
  image {
    name = "rancher/local-path-provisioner:v0.0.11"
  }
  
  image {
    name = "rancher/metrics-server:v0.3.6"
  }

}

## Deploy k8s dashboard
k8s_config "dashboard" {
    cluster = "k8s_cluster.k8s"

    paths = [
        "./k8s_config/k8s-dashboard.yml"
    ]
  
    wait_until_ready = true
}


## Deploy two-tier webapp

#k8s_config "web-app" {
#    depends_on = ["helm.consul"]
#    cluster = "k8s_cluster.k8s"
#
#    paths = [
#        "./k8s_config/web.yml",
#        "./k8s_config/api.yml"
#    ]
#  
#    wait_until_ready = true
#}
