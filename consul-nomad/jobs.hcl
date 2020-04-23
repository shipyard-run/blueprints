nomad_job "jobs" {
  cluster = "nomad_cluster.dev"
  paths = [
    "./nomad_config/jaeger.nomad",
    "./nomad_config/web.nomad",
    "./nomad_config/api.nomad",
    "./nomad_config/payment.nomad",
    "./nomad_config/currency.nomad"
  ]
}
