nomad_job "web" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/web.hcl"]
}

nomad_job "api" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/api.hcl"]
}

nomad_job "payments" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/payments.hcl"]
}

nomad_job "postgres" {
    cluster = "nomad_cluster.nomad"
    paths = ["./nomad_config/postgres.hcl"]
}