nomad_job "autoscaler" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/autoscaler.hcl"]
}