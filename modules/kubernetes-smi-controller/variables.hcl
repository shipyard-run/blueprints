# Setting to false does not install the controller, only installs CRDs and sets up the Webhooks
# useful for running locally
variable "smi_controller_enabled" {
  default = "true"
}

# The repository for the controller
variable "smi_controller_repository" {
  default = "nicholasjackson/smi-controller-example"
}

variable "smi_controller_helm_chart" {
  default = "github.com/servicemeshinterface/smi-controller-sdk?ref=refactor/helm//smi-controller"
}

# The tag for the controller
variable "smi_controller_tag" {
  default = "0.1.0"
}

variable "smi_controller_namespace" {
  default = "smi"
}

variable "smi_controller_webhook_enabled" {
  default = "true"
}

variable "smi_controller_webhook_service" {
  default = "smi-webhook"
}

variable "smi_controller_webhook_port" {
  default = 443
}

variable "smi_controller_additional_dns" {
  default = "localhost"
}

variables "smi_controller_additional_env" {
  default = ""
}

# Allows setting of full helm values, overrides previous two varaibles
variable "smi_controller_helm_values" {
  default = "${data("smi_controller")}/smi-controller-values.yaml"
}
