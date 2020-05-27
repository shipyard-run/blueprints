nomad_job "gateway-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/gateway.hcl"]
}

nomad_job "gateway-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/cloud/gateway.hcl"]
}