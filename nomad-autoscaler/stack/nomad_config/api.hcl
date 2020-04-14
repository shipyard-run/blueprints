job "api" {
  datacenters = ["dc1"]
  type = "service"

  group "api" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "api"
       port = "9090"
       tags = ["scrape"]

       connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://10.5.0.2:9125"
                    }
                    
                    upstreams {
                        destination_name = "payments"
                        local_bind_port = 9091
                    }
                }
            }
        }
    }

    task "api" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "api"
          MESSAGE = "ok"
          UPSTREAM_URIS = "http://localhost:9091"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 50
        memory = 64
      }
    }
  }
}
