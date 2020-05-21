nomad_job "nginx-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/nginx.hcl"]
}

nomad_job "unicorn-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/unicorn.hcl"]
}

nomad_job "cache-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/cache.hcl"]
}

nomad_job "database-onprem" {
    cluster = "nomad_cluster.onprem"
    paths = ["./nomad_jobs/onprem/database.hcl"]
}