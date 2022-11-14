variable "cn_network" {
  default = "dc1"
}

variable "cn_consul_server_config" {
  default = "${file("${file_dir()}/consul_config/consul.hcl")}"
}

variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

variable "cn_consul_cluster_name" {
  default = "container.consul"
}

variable "cn_consul_open_browser" {
  default = true
}

variable "cn_nomad_open_browser" {
  default = true
}

network "dc1" {
  subnet = "10.15.0.0/16"
}

variable "vault_data" {
  default = "${file_dir()}/vault_config"
}

# Bootstrap script that is executed after Vault starts
# can be used to initially configure Vault
variable "vault_bootstrap_script" {
  default = <<-EOF
  #!/bin/sh -e

  vault status

  vault policy write nomad-server nomad-server-policy.hcl
  vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json

  VAULT_NOMAD_TOKEN=$(vault token create -policy nomad-server -orphan -period 100h | grep 'token ' | awk '{print $2;}')
  echo -n "$VAULT_NOMAD_TOKEN" > /data/vault_nomad_token.txt

  # for example only - create an example secret
  vault kv put secret/hello foo=world
  EOF
}

# Path to additional Nomad server config to merge to server nodes
variable "cn_nomad_server_config" {
  default = "${file_dir()}/vault_config/nomad-server.hcl"
}

template "vault_nomad_server_config" {
  depends_on = ["module.vault"]
  source = <<-EOF
vault {
  enabled          = true
  address          = "http://localhost:8200"
  create_from_role = "nomad-cluster"

  token            = "#{{ .Vars.vault_nomad_token }}"
}
EOF

  vars = {
    vault_nomad_token = file("${file_dir()}/vault_config/vault_nomad_token.txt")
  }

  destination = "${var.cn_nomad_server_config}"
}

module "vault" {
  source = "github.com/shipyard-run/blueprints//modules/vault-dev"
}

module "nomad_consul" {
  depends_on = ["module.vault"]
  source = "github.com/shipyard-run/blueprints//modules/consul-nomad"
  #source = "../modules/consul-nomad"
}
