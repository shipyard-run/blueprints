nomad_job "api-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/api.hcl"]
}