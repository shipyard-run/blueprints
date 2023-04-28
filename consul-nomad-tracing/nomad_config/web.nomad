job "web" {
  datacenters = ["dc1"]

  type = "service"

  group "web" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 30
    }

    service {
      name = "web"
      tags = ["global", "app"]
      port = "9090"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "api"
              local_bind_port  = 9091
            }
            upstreams {
              destination_name = "payment"
              local_bind_port  = 9092
            }
          }
        }
      }
    }

    network {
      mode = "bridge"

      port "http" {
        static = 9090
        to     = 9090
      }
    }

    task "web" {
      driver = "docker"

      logs {
        max_files     = 2
        max_file_size = 10
      }

      env {
        LISTEN_ADDR    = "0.0.0.0:9090"
        UPSTREAM_URIS  = "http://localhost:9091,http://localhost:9092"
        MESSAGE        = "Hello World ${node.unique.name} ${node.unique.id}"
        NAME           = "Ingress"
        SERVER_TYPE    = "http"
        TRACING_ZIPKIN = "http://10.15.0.200:9411"
      }

      config {
        image = "nicholasjackson/fake-service:v0.24.2"
      }

      resources {
        cpu    = 100
        memory = 256 # 256MB
      }
    }
  }
}
