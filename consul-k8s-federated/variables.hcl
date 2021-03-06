variable "consul_k8s_module" {
  description = <<EOT
  Location and version of the module for Consul Kubernetes, can be set to a
  local path for testing.
  EOT

  default = "github.com/shipyard-run/blueprints//modules/kubernetes-consul"
}

variable "install_example_app" {
  description = <<EOF
  Install an example applcation that shows how to call an upstream in another datacenter.

  This application exposes two endpoints:

  http://localhost:19091 Source traffic in Kubernetes with an upstream running on Linux
  http://localhost:19092 Source traffic in Linux with an upstream running on Kubernetes
  
  http://localhost:19093 Source traffic in Kubernetes with an upstream running on Windows
  http://localhost:19094 Source traffic in Windows with an upstream running on Kubernetes
  EOF

  default = false
}

variable "enable_linux_dc" {
  description = "Enables and configures a Linux based (faux VM) datacenter"
  default = true
}