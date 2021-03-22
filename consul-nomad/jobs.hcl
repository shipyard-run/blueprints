nomad_job "jobs" {
  cluster = var.cn_nomad_cluster_name
  paths = [
    "./nomad_config/web.nomad",
    "./nomad_config/api.nomad",
    "./nomad_config/payment.nomad",
    "./nomad_config/currency.nomad"
  ]
}