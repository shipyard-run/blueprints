module "smi_controller" {
  disabled = var.consul_smi_controller_enabled ? false : true

  depends_on = ["helm.consul"]
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-smi-controller"
  #source = "../../hashicorp-blueprints/modules/smi-controller"
}
