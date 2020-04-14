job "payments" {
  datacenters = ["dc1"]
  type = "service"

  group "payments" {
    count = 1

    scaling {
        enabled = true
        min     = 1
        max     = 3

        policy {
            source = "prometheus"
            query  = "haproxy_backend_http_response_time_average_seconds{backend=\"http_back\"}"

            strategy = {
                name = "target-value"

                config = {
                    target = 0.9
                }
            }
        }
    }

    network {
        mode = "bridge"
    }

    service {
       name = "payments"
       port = "9090"

       connect {
            sidecar_service {
                proxy {
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
          UPSTREAM_URIS = "http://localhost:9091,http://localhost:9092"
          TIMING_50_PERCENTILE = "20ms"
          TIMING_90_PERCENTILE = "50ms"
          TIMING_99_PERCENTILE = "200ms"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
