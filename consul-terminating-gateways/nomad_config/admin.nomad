job "adminer" {
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

  group "adminer" {
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
      name = "adminer"
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
        static = 8080
        to = 8080
      }
    }

    task "admin" {
      driver = "docker"

      config {
        image = "adminer"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }


    }
  }
}
