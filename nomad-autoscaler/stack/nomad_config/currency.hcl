job "currency" {
  datacenters = ["dc1"]
  type = "service"

  group "currency" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "currency"
       port = "9090"

       connect {
         sidecar_service {}
       }
    }

    task "currency" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "currency"
          MESSAGE = "$200"
          TIMING_50_PERCENTILE = "20ms"
          TIMING_90_PERCENTILE = "50ms"
          TIMING_99_PERCENTILE = "200ms"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 50
        memory = 64
      }
    }
  }
}
