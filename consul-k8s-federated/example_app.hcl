module "example" {
  disabled = var.install_example_app == false

  source = "./example_app"
}
