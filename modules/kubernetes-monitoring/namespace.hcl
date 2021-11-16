template "monitoring_namespace" {
  disabled = var.monitoring_namespace == "default"

  source = <<EOF
  kind: Namespace
  apiVersion: v1
  metadata:
    name: ${var.monitoring_namespace}
    labels:
      name: ${var.monitoring_namespace}
  EOF

  destination = "${data("monitoring")}/namespace.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

k8s_config "monitoring_namespace" {
  disabled   = var.monitoring_namespace == "default"
  cluster    = "k8s_cluster.${var.monitoring_k8s_cluster}"
  depends_on = ["template.monitoring_namespace"]

  paths = [
    "${data("monitoring")}/namespace.yaml",
  ]

  wait_until_ready = true
}