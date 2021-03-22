nomad_job "jobs" {
  cluster = var.cn_nomad_cluster_name

  paths = [
    "./nomad_config/api.nomad",
  ]

  health_check {
    nomad_jobs = ["api"]
    timeout = "60s"
  }
}