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

# ingress "consul-http_1" {
#   target = "k8s_cluster.k8s"
#   service  = "svc/hashicorp-consul-ui"
    
#   network  {
#     name = "network.local"
#   }

#   port {
#     local  = 80
#     remote = 80
#     host   = 18501
#   }
# }

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
