# To access the services running in your k8s cluster externally you need to define an ingress.

## Access k8s dashboard on http://localhost:18443
ingress "k8s-dashboard" {
    target = "k8s_cluster.k8s"
    service = "svc/kubernetes-dashboard"
    namespace = "kubernetes-dashboard"

    network  {
      name = "network.local"
    }

    port {
        remote = 8443
        local = 8443
        host = 18443
    }
}


## Access Consul UI on http://localhost:18500

# ingress "consul-http" {
#   target = "k8s_cluster.k8s"
#   service  = "svc/hashicorp-consul-server"
    
#   network  {
#     name = "network.local"
#   }

#   port {
#     local  = 8500
#     remote = 8500
#     host   = 18500
#   }
# }


## Access webapp ui on http://localhost:9090

#ingress "web-api" {
#    target = "k8s_cluster.k8s"
#    service = "svc/web"
#    
#    network  {
#      name = "network.local"
#    }
#
#    port {
#        local = 9090
#        remote = 9090
#        host = 9090
#    }
#}
