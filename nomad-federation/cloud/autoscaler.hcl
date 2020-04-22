nomad_job "autoscaler" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/autoscaler.hcl"]
}