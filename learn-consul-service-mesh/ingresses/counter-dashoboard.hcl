ingress "counter-dashboard" {
   target = "k8s_cluster.k8s"
   service = "svc/dashboard-service-load-balancer"
   
   network  {
     name = "network.local"
   }

   port {
       local = 80
       remote = 80
       host = 8080
   }
}
