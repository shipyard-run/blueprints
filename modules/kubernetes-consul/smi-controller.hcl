template "custom_smi_controller_config" {
  disabled = var.consul_smi_controller_enabled ? false : true

  source      = file("./helm/consul_smi_values.yaml")
  destination = "${data("smi_controller")}/consul_smi_controller_values.yaml"

  vars = {
    tls_enabled                      = var.consul_tls_enabled
    acl_enabled                      = var.consul_acls_enabled
    consul_smi_controller_repository = var.consul_smi_controller_repository
    consul_smi_controller_tag        = var.consul_smi_controller_tag
  }
}

# override the helm values
variable "smi_controller_helm_values" {
  default = "${data("smi_controller")}/consul_smi_controller_values.yaml"
}

variable "smi_controller_helm_chart" {
  default = "github.com/servicemeshinterface/smi-controller-sdk?ref=f-helm-config-options/helm//smi-controller"
}

template "smi_setup_script" {
  disabled = var.consul_smi_controller_enabled ? false : true

  depends_on = ["helm.consul"]

  source = <<EOF
  #!/bin/sh -e

  # create a service pointing to the consul server for the smi namespace
  echo "
  kind: Service
  apiVersion: v1
  metadata:
    name: consul-server
    namespace: smi
  spec:
    type: ExternalName
    externalName: consul-server.default.svc.cluster.local
  " | kubectl apply -f -

  # add the server ca certificate
  kubectl get secret consul-server-cert -o json \
    | jq 'del(.metadata["namespace","creationTimestamp","resourceVersion","selfLink","uid"])' \
    | kubectl apply -n smi -f -

  # add the acl token for the controller
  kubectl get secret consul-controller-acl-token -o json \
    | jq 'del(.metadata["namespace","creationTimestamp","resourceVersion","selfLink","uid"])' \
    | kubectl apply -n smi -f -
  EOF

  destination = "${var.consul_data_folder}/smi-secrets.sh"

  vars = {
    port        = var.consul_ports_api == 0 ? (var.consul_tls_enabled == true ? 8501 : 8500) : var.consul_ports_api
    tls_enabled = var.consul_tls_enabled
    acl_enabled = var.consul_acls_enabled
  }
}

# we need to copy some secrets from the consul controller namespace into the SMI namespace
exec_remote "exec_smi_setup" {
  disabled = var.consul_smi_controller_enabled ? false : true

  depends_on = ["helm.consul"]

  image {
    name = "shipyardrun/tools:v0.5.0"
  }

  network {
    name = "network.${var.consul_k8s_network}"
  }

  cmd  = "/bin/bash"
  args = ["-c", "chmod +x /smi-secrets.sh && /smi-secrets.sh"]

  # Mount a volume containing the config
  volume {
    source      = k8s_config_docker("${var.consul_k8s_cluster}")
    destination = "/kubeconfig.yaml"
  }

  volume {
    source      = "${var.consul_data_folder}/smi-secrets.sh"
    destination = "/smi-secrets.sh"
  }

  env {
    key   = "KUBECONFIG"
    value = "/kubeconfig.yaml"
  }
}


module "smi_controller" {
  disabled = var.consul_smi_controller_enabled ? false : true

  depends_on = ["helm.consul"]

  source = "github.com/shipyard-run/blueprints/modules//kubernetes-smi-controller"
  #source = "../kubernetes-smi-controller"
}