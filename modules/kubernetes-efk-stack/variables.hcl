variable "efk_helm_values" {
  default = "${file_dir()}/helm/efk.yaml"
}

variable "kibana_port" {
  default = 5601
}

variable "namespace" {
  default = "logging"
}

variable "efk_folder" {
  description = ""
  default     = "run.sh"
}

variable "efk_k8s_network" {
  description = ""
  default     = "dc1"
}