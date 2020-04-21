nomad_job "gateway-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/gateway.hcl"]
}