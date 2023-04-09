variable "efk_helm_values" {
  default = "${file_dir()}/helm/efk.yaml"
}

variable "kibana_port" {
  default = 5601
}

variable "namespace" {
  default = "logging"
}