// set the variable for the network
variable "cn_network" {
  default = "dc1"
}

variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

module "consul_nomad" {
  source = "../"
}

nomad_job "jobs" {
  cluster = var.cn_nomad_cluster_name
  paths = [
    "./web.nomad",
    "./api.nomad",
  ]
}

nomad_ingress "web" {
  cluster = var.cn_nomad_cluster_name
  job = "web"
  group = "web"
  task = "web"
  
  network {
    name = "network.dc1"
  }

  port {
    local  = 9090
    remote = "http"
    host   = 19090
  }
}
