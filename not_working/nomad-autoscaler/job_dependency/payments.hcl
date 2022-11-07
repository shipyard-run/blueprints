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

                    upstreams {
                        destination_name = "currency"
                        local_bind_port = 9092
                    }
                }
            }
        }
    }

    task "wait-for-database" {
        driver = "docker"

        config {
            image        = "busybox:1.28"
            command      = "sh"
            args         = ["-c", "echo -n 'Waiting for the database to be up '; until nslookup postgres.service.consul 10.5.0.2:8600 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
        }

        resources {
            cpu    = 50
            memory = 64
        }

        lifecycle {
            hook    = "prestart"
            sidecar = false
        }
    }

    task "payments" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.24.2"
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
