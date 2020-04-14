job "api" {
  datacenters = ["dc1"]
  type = "service"

  group "api" {
    count = 1

    scaling {
        enabled = true
        min     = 1
        max     = 3

        policy {
            source = "prometheus"
            query  = "scalar(avg((haproxy_server_current_sessions{backend=\"http_back\"}) and (haproxy_server_up{backend=\"http_back\"} == 1)))"

            strategy = {
                name = "target-value"

                config = {
                    target = 20
                }
            }
        }
    }

    network {
        mode = "bridge"
    }

    service {
       name = "api"
       port = "9090"

       connect {
            sidecar_service {
                proxy {
                    upstreams {
                        destination_name = "redis"
                        local_bind_port = 9091
                    }

                    upstreams {
                        destination_name = "payments"
                        local_bind_port = 9092
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
          UPSTREAM_URIS = "http://localhost:9091,http://localhost:9092"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
