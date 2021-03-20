nomad_job "jobs" {
  cluster = "nomad_cluster.dev"
  paths = [
    "./nomad_config/api.nomad",
    "./nomad_config/api2.nomad"
  ]

  health_check {
    nomad_jobs = ["api", "api2"]
    timeout = "60s"
  }
}
