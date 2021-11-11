helm "flagger" {
  depends_on = ["helm.consul"]
  disabled   = var.consul_flagger_enabled == false

  cluster = "k8s_cluster.${var.consul_k8s_cluster}"

  chart = "github.com/fluxcd/flagger/charts//flagger"

  values = "${file_dir()}/helm/flagger_values.yaml"
}