job "currency" {
  datacenters = ["dc1"]
  type = "service"

  group "currency" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "currency"
       port = "9090"

       connect {
         sidecar_service {}
       }
    }

    task "central-config" {
        driver = "docker"

        template {
            destination   = "local/central-config.sh"
            data = <<EOH
consul config write - <<EOF
kind="service-defaults"
name="currency"
protocol="http"
EOF
EOH
        }
        
        lifecycle {
            hook = "prestart"
        }

        config {
            image = "consul:1.7.2"
            command = "sh"
            args = ["/central-config.sh"]
            volumes = ["local/central-config.sh:/central-config.sh"]
        }

        env {
            CONSUL_HTTP_ADDR="${attr.unique.network.ip-address}:8500"
        }
    }

    task "currency" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "currency"
          MESSAGE = "$200"
          TIMING_50_PERCENTILE = "20ms"
          TIMING_90_PERCENTILE = "50ms"
          TIMING_99_PERCENTILE = "200ms"
          TIMING_VARIANCE = "25"
          HTTP_CLIENT_KEEP_ALIVES = "false"
      }

      resources {
        cpu    = 50
        memory = 128
      }
    }
  }
}
