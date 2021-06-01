module "linux" {
  depends_on = ["module.consul"]

  source = "./linux"
}