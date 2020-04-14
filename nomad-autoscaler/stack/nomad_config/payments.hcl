job "payments" {
  datacenters = ["dc1"]
  type = "service"

  group "payments" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "payments"
       port = "9090"

       connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://10.5.0.2:9125"
                    }

                    upstreams {
                        destination_name = "postgres"
                        local_bind_port = 9091
                    }
                }
            }
        }
    }

    task "payments" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "payments"
          MESSAGE = "payment successful"
          UPSTREAM_URIS = "http://localhost:9091"
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
