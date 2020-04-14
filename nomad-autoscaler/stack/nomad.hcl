nomad_cluster "nomad" {
  version = "v0.11.0"

  nodes = 1 // default

  network {
    name = "network.cloud"
  }

//   image {
//       name = "haproxy:2.0"
//   }

//   image {
//       name = "nicholasjackson/fake-service:v0.9.0"
//   }

//   image {
//       name = "prom/prometheus:latest"
//   }

//   image {
//       name = "grafana/grafana"
//   }

  volume {
      source = "./consul_config"
      destination = "/config"
  }
}