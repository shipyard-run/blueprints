nomad_job "jobs" {
  cluster = "nomad_cluster.local"
  paths = [
    "./nomad_config/web.nomad",
    "./nomad_config/api.nomad",
    "./nomad_config/payment.nomad",
    "./nomad_config/currency.nomad"
  ]
}