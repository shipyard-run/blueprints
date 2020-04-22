nomad_job "web-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/web.hcl"]
}

nomad_job "api-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/api.hcl"]
}

nomad_job "database-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/database.hcl"]
}