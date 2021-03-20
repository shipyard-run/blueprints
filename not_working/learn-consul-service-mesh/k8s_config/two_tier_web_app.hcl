
# Use this file to deploy a web application composed by the services defined in the `paths`
# using shipyard.
# shipyard run ./k8s_config/two_tier_web_app.hcl

k8s_config "web-app" {
  #  depends_on = ["helm.consul"]
   cluster = "k8s_cluster.k8s"

   paths = [
       "./web.yml",
       "./api.yml"
   ]
 
   wait_until_ready = true
}
