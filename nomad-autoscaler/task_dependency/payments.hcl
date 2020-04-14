job "payments" {
  datacenters = ["dc1"]
  type = "service"

  group "payments" {
    count = 1

    network {
        mode = "bridge"
    }

    service {
       name = "payments"
       port = "9090"

       connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://10.5.0.2:9125"
                    }

                    upstreams {
                        destination_name = "postgres"
                        local_bind_port = 9091
                    }

                    upstreams {
                        destination_name = "currency"
                        local_bind_port = 9092
                    }
                }
            }
        }
    }

    task "central-config" {
        driver = "docker"

        template {
            destination   = "local/central-config.sh"
            data = <<EOH
consul config write - <<EOF
kind="service-defaults"
name="payments"
protocol="http"
EOF

consul config write - <<EOF
kind="service-router"
name="payments"
routes = [
  {
    match {
      http {
        path_prefix = "/currency"
      }
    }

    destination {
      service = "currency"
    }
  },
]
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

    task "payments" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.9.0"
      }

      env {
          NAME = "payments"
          MESSAGE = "payment successful"
          UPSTREAM_URIS = "http://localhost:9091,http://localhost:9092"
          TIMING_50_PERCENTILE = "20ms"
          TIMING_90_PERCENTILE = "50ms"
          TIMING_99_PERCENTILE = "200ms"
          TIMING_VARIANCE = "25"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
