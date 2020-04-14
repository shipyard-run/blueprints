job "database" {
  datacenters = ["dc1"]
  type = "service"

  group "database" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "postgres"
       port = "5432"

       connect {
         sidecar_service {
             proxy {
                 config {
                     envoy_dogstatsd_url = "udp://10.5.0.2:9125"
                 }
             }
         }
       }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "postgres"
          MESSAGE = "10 rows returned"
          LISTEN_ADDR = "0.0.0.0:5432"
          TIMING_50_PERCENTILE = "200ms"
          TIMING_90_PERCENTILE = "300ms"
          TIMING_99_PERCENTILE = "1s"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 50
        memory = 64
      }
    }
  }
}
