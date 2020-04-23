nomad_job "prometheus-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/prometheus.hcl"]
}