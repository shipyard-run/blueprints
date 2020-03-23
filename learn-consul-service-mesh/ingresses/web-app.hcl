ingress "web-api" {
   target = "k8s_cluster.k8s"
   service = "svc/web"
   
   network  {
     name = "network.local"
   }

   port {
       local = 9090
       remote = 9090
       host = 9090
   }
}
