
# The repository for the controller
variable "smi_controller_repository" {
  default = "nicholasjackson/smi-controller-example"
}

# The tag for the controller
variable "smi_controller_tag" {
  default = "dev"
}

# Allows setting of full helm values, overrides previous two varaibles
variable "smi_controller_helm_values" {
  default = "${file_dir()}/helm/smi-controller-values.yaml"
}