nomad_job "web-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/web.hcl"]
}

nomad_job "api-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/api.hcl"]
}

nomad_job "database-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/database.hcl"]
}

nomad_job "api-cloud" {
    cluster = "nomad_cluster.cloud"
    paths = ["./nomad_jobs/cloud/api.hcl"]
}