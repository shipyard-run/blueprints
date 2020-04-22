nomad_job "monitoring" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/prometheus.hcl"]
}