variable "consul_k8s_module" {
  description = <<EOT
  Location and version of the module for Consul Kubernetes, can be set to a
  local path for testing.
  EOT

  default = "github.com/shipyard-run/blueprints?ref=2681ce0e63f0951fc8abaa53c029e3f5504896bf/modules//kubernetes-consul"
  #default = "./modules/kubernetes-consul"
}

variable "install_example_app" {
  description = <<EOF
  Install an example applcation that shows how to call an upstream in another datacenter.

  This application exposes two endpoints:

  http://localhost:19091 Source traffic in Kubernetes with an upstream running on Linux 
  http://localhost:19092 Source traffic in Linux with an upstream running on Kubernetes 
  EOF

  default = true
}

variable "enable_linux_dc" {
  description = "Enables and configures a Linux based (faux VM) datacenter"
  default     = true
}

variable "consul_release_controller_enabled" {
  default = false
}
