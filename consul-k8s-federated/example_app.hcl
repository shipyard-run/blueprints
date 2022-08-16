module "example" {
  depends_on = ["module.vms", "module.kubernetes_consul"]

  disabled = var.install_example_app == false

  source = "./example_app"
}
