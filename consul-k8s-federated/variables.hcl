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

  http://localhost:19091 Source traffic in Kubernetes (dc1) with an upstream running on Linux (dc2)
  http://localhost:19092 Source traffic in Linux (dc2) with an upstream running on Kubernetes (dc1)
  EOF

  default = false
}