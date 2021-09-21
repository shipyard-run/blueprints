job "currency" {
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
  
  group "currency" {
    count = 1
    
    restart {
      # The number of attempts to run the job within the specified interval.
      attempts = 2
      interval = "30m"

      delay = "15s"

      mode = "fail"
    }

    ephemeral_disk {
      size = 30
    }
        
    network {
      mode = "bridge"
      mbits = 10
      port "http" {
        to = 9093
      }
    }
      
    service {
      name = "currency"
      tags = ["global","app"]
      port = "9093"

      connect {
       sidecar_service {}
      }
    }

    task "currency" {
      driver = "docker"
      
      logs {
        max_files     = 2
        max_file_size = 10
      }

      env {
        LISTEN_ADDR = "0.0.0.0:9093"
        MESSAGE = "Hello World"
        NAME = "Currency"
        SERVER_TYPE = "http"
        TRACING_ZIPKIN = "http://10.15.0.200:9411"
      }

      config {
        image = "nicholasjackson/fake-service:v0.20.0"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }
    }
  }
}
