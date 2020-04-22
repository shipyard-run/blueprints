job "database" {
    datacenters = ["onprem"]
    region = "onprem"
    type = "service"

    group "database" {
        count = 1

        network {
            mode = "bridge"
        }

        service {
            name = "database"
            port = "5432"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                        }
                        
                        upstreams {
                            destination_name = "exporter-statsd"
                            local_bind_port = 9125
                        }
                    }
                }
            }
        }

        task "service-defaults" {
            driver = "docker"

            template {
                destination   = "local/central-config.sh"
                data = <<EOH
consul config write - <<EOF
kind = "service-defaults"
name = "database"
protocol="http"
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "database"
redirect {
  service    = "database"
  datacenter = "onprem"
}
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

        task "postgres" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.9.0"
            }

            env {
                NAME = "postgres"
                MESSAGE = "25 rows returned"
                LISTEN_ADDR = "0.0.0.0:5432"
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
