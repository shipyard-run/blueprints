variable "vault_helm_values" {
  default = "${file_dir()}/helm/vault_values.yaml"
}

variable "vault_api_port" {
  default = 8200
}