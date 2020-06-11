nomad_job "jobs" {
  cluster = "nomad_cluster.dev"
  paths = [
    "./nomad_config/admin.nomad"
  ]

  health_check {
    nomad_jobs = ["adminer"]
    timeout = "60s"
  }
}
