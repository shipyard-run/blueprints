variable "consul_k8s_module" {
  description = <<EOT
  Location and version of the module for Consul Kubernetes, can be set to a
  local path for testing.
  EOT

  default = "github.com/shipyard-run/blueprints?ref=891c937844bdbec673f5428b1a3c8bff4e207727/modules//kubernetes-consul"
  #default = "../modules/kubernetes-consul"
}

variable "consul_docker_module" {
  description = <<EOT
  Location and version of the module for Consul Docker, can be set to a
  local path for testing.
  EOT

  default = "github.com/shipyard-run/blueprints?ref=891c937844bdbec673f5428b1a3c8bff4e207727/modules//kubernetes-consul"

  #default = "../modules/consul-docker"
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


# Enable server security
