nomad_job "prometheus-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/prometheus.hcl"]
}

nomad_job "prometheus-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/cloud/prometheus.hcl"]
}

nomad_job "grafana-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/grafana.hcl"]
}