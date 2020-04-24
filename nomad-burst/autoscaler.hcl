nomad_job "autoscaler" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/cloud/autoscaler.hcl"]
}