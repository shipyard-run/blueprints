job "web" {
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
  
  group "web" {
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
      name = "web"
      tags = ["global","app"]
      port = "9090"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "api"
              local_bind_port = 9091
            }
            upstreams {
              destination_name = "payment"
              local_bind_port = 9092
            }
          }
        }
      }
    }

    network {
      mode = "bridge"
      mbits = 10

      port "http" {
        static = 9090
        to = 9090
      }
    }

    task "web" {
      driver = "docker"

      env {
        LISTEN_ADDR = "0.0.0.0:9090"
        UPSTREAM_URIS = "http://localhost:9091,http://localhost:9092"
        MESSAGE = "Hello World"
        NAME = "Ingress"
        SERVER_TYPE = "http"
        TRACING_ZIPKIN = "http://10.15.0.200:9411"
      }

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }
      

    }
  }
}
