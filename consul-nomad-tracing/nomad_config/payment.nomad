job "payment" {
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
  
  group "payment" {
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
        
    network {
      mode = "bridge"
      mbits = 10
      port "http" {
        to = 9092
      }
    }
      
    service {
      name = "payment"
      tags = ["global","app"]
      port = "9092"

      connect {
       sidecar_service {
        proxy {
          upstreams {
              destination_name = "currency"
              local_bind_port = 9093
          }
        }
       }
      }
    }

    task "payment" {
      driver = "docker"

      template {
        destination = "secrets/file.env"
        env         = true
        data        = <<EOF
LISTEN_ADDR = "0.0.0.0:9092"
UPSTREAM_URIS = "http://localhost:9093"
MESSAGE = "Hello World"
NAME = "Payment"
SERVER_TYPE = "http"
TRACING_ZIPKIN = "http://10.15.0.200:9411"
VAULT_SECRET={{with secret "secret/hello"}}{{.Data.foo}}{{end}}
EOF
      }

      config {
        image = "nicholasjackson/fake-service:v0.24.2"

        port_map {
        }
      }

      resources {
        cpu    = 100
        memory = 256 # 256MB

      }
    }
  }
}
