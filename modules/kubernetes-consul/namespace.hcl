template "consul_namespace" {
  disabled = var.consul_namespace == "default"

  source = <<EOF
  kind: Namespace
  apiVersion: v1
  metadata:
    name: ${var.consul_namespace}
    labels:
      name: ${var.consul_namespace}
  EOF

  destination = "${data("consul")}/namespace.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

k8s_config "consul_namespace" {
  disabled   = var.consul_namespace == "default"
  cluster    = "k8s_cluster.${var.consul_k8s_cluster}"
  depends_on = ["template.consul_namespace"]

  paths = [
    "${data("consul")}/namespace.yaml",
  ]

  wait_until_ready = true
}