
k8s_config "web-app" {
  #  depends_on = ["helm.consul"]
   cluster = "k8s_cluster.k8s"

   paths = [
       "./web.yml",
       "./api.yml"
   ]
 
   wait_until_ready = true
}
