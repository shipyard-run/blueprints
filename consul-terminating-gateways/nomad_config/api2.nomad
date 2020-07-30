job "api2" {
  datacenters = ["dc1"]

  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "api" {
    count = 1

    restart {
      # The number of attempts to run the job within the specified interval.
      attempts = 2
      interval = "30m"

      delay = "15s"

      mode = "fail"
    }

    ephemeral_disk {
      size = 300
    }

    service {
      name = "api"
      tags = ["global","app"]
      port = "8080"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "mysql"
              local_bind_port = 3306
            }
          }
        }
      }
    }

    network {
      mode = "bridge"
      mbits = 10

      port "http" {
        static = 8081
        to = 8080
      }
    }

    task "admin" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.14.1"
      }
      
      env {
        LISTEN_ADDR = ":8080"
        NAME = "API2"
        UPSTREAM_URIS = "http://localhost:3306"
        HTTP_CLIENT_KEEP_ALIVES = "true"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }


    }
  }
}