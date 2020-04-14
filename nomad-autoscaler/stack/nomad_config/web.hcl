job "web" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 1

    network {
        mode = "bridge"

        port "http" {
            static = 80
            to = 9090
        }
    }

    service {
       name = "web"
       port = "80"

       connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://10.5.0.2:9125"
                    }
                    
                    upstreams {
                        destination_name = "api"
                        local_bind_port = 9091
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
          MESSAGE = "ok"
          UPSTREAM_URIS = "http://localhost:9091"
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
