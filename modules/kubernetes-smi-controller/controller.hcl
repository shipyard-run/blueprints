# Create the helm values
template "smi_controller_config" {

  source = <<EOF
controller:
  enabled: "true"

  image:
    repository: "${var.smi_controller_repository}"
    pullPolicy: IfNotPresent
    # Overrides the image tag whose default is the chart appVersion.
    tag: "${var.smi_controller_tag}"
EOF

  destination = "${file_dir()}/helm/smi-controller-values.yaml"
}

helm "smi-controler" {
  # wait for certmanager to be installed and the template to be processed
  depends_on = ["template.smi_controller_config", "helm.cert-manager"]

  cluster = "k8s_cluster.${var.smi_controller_k8s_cluster}"
  namespace = "smi"

  chart = "github.com/nicholasjackson/smi-controller-sdk/helm//smi-controller"

  values = var.smi_controller_helm_values
}