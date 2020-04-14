nomad_job "example" {
  cluster = "nomad_cluster.dev"
  paths = ["./nomad_config/example.nomad"]
}