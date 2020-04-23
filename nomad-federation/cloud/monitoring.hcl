nomad_job "prometheus-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/prometheus.hcl"]
}