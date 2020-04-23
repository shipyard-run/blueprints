job "web" {
  datacenters = ["onprem"]
  region = "onprem"
  type = "service"

  group "web" {
    count = 1

    network {
        mode = "bridge"

        port "http" {
            static = 80
            to = 80
        }

        port "prometheus" {
            to = "9102"
        }
    }

    service {
        name = "exporter"
        port = "prometheus"

        connect {
            sidecar_service {}
        }
    }

    task "exporter" {
        driver = "docker"

        config {
            image = "prom/statsd-exporter"
        }

        resources {
            cpu    = 50
            memory = 64
        }

        lifecycle {
            hook = "prestart"
            sidecar = true
        }
    }

    service {
       name = "web"
       port = "80"

       connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                        envoy_stats_tags = ["datacenter=onprem"]
                    }
                    
                    upstreams {
                        destination_name = "api"
                        local_bind_port = 9090
                    }
                }
            }
        }
    }

    task "web" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "web"
          MESSAGE = "hello world"
          LISTEN_ADDR = "0.0.0.0:80"
          UPSTREAM_URIS = "http://localhost:9090"
          TIMING_VARIANCE = "25"
          HTTP_CLIENT_KEEP_ALIVES = "false"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
