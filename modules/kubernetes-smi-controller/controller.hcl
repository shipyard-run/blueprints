# Create the helm values
template "smi_controller_config" {

  source = <<EOF
controller:
  enabled: ${var.smi_controller_enabled}
  ${var.smi_controller_additional_env}

  image:
    repository: "${var.smi_controller_repository}"
    pullPolicy: IfNotPresent
    # Overrides the image tag whose default is the chart appVersion.
    tag: "${var.smi_controller_tag}"

webhook:  
  enabled: ${var.smi_controller_webhook_enabled}
  service: "${var.smi_controller_webhook_service}"
  port: ${var.smi_controller_webhook_port}
  additionalDNSNames:
    - ${var.smi_controller_additional_dns}
EOF

  destination = "${data("smi_controller")}/smi-controller-values.yaml"
}

helm "smi-controller" {
  # wait for certmanager to be installed and the template to be processed
  depends_on = ["template.smi_controller_config", "helm.cert-manager"]

  cluster = "k8s_cluster.${var.smi_controller_k8s_cluster}"
  namespace = var.smi_controller_namespace

  chart = var.smi_controller_helm_chart

  values = var.smi_controller_helm_values
}