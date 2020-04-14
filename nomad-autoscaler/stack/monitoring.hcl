nomad_job "monitoring" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/monitoring.hcl"]
}