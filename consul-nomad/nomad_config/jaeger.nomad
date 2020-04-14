job "jaeger" {
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
  
  group "cache" {
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

    task "jaeger-all-in-one" {
      driver = "docker"

      env {
        COLLECTOR_ZIPKIN_HTTP_PORT = 9411
      }

      config {
        image = "jaegertracing/all-in-one:1.13"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10
          port "udp1" {static = 5775}
          port "udp2" {static = 6831}
          port "udp3" {static = 6832}
          port "tcp1" {static = 5778}
          port "http" {static = 16686}
          port "http2" {static = 14268}
          port "http3" {static = 9411}
        }
      }
      
      service {
        name = "jaeger"
        tags = ["global", "tracing"]
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

    }
  }
}
