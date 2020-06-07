# Shipyard can automatically deploy helm charts in the blueprint.
# Uncomment this block to have Consul Connect deployed in your k8s cluster automatically.

#helm "consul" {
#  cluster = "k8s_cluster.k8s"
#  chart = "./helm-charts/consul-helm-0.18.0"
#  values = "./helm-charts/consul-values.yml"
#
#  health_check {
#    timeout = "60s"
#    pods = ["release=consul"]
#  }
#}
