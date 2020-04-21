nomad_job "gateway-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/gateway.hcl"]
}