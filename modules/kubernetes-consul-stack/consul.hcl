module "consul" {
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-consul"
  #source = "${file_dir()}/../../../modules/kubernetes/consul"
}

module "smi_controller" {
  depends_on = ["module.consul"]
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-smi-controller"
  #source = "../../hashicorp-blueprints/modules/smi-controller"
}