module "smi_controller" {
  disabled = var.consul_enable_smi_controller ? false : true

  depends_on = ["module.consul"]
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-smi-controller"
  #source = "../../hashicorp-blueprints/modules/smi-controller"
}
