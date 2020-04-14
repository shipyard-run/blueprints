job "cache" {
  datacenters = ["dc1"]
  type = "service"

  group "cache" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "redis"
       port = "6379"

       connect {
         sidecar_service {}
       }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      resources {
        cpu    = 50
        memory = 64
      }

      env {
          NAME = "redis"
          MESSAGE = "ok"
          LISTEN_ADDR = "0.0.0.0:6379"
          TIMING_50_PERCENTILE = "20ms"
          TIMING_90_PERCENTILE = "50ms"
          TIMING_99_PERCENTILE = "200ms"
          TIMING_VARIANCE = "25"
      }
    }
  }
}
