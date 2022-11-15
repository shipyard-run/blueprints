job "database" {
    datacenters = ["onprem"]
    region = "onprem"
    type = "service"

    group "database" {
        count = 1

        network {
            mode = "bridge"

            port "prometheus" {
                to = "9102"
            }
        }

        service {
            name = "exporter"
            port = "prometheus"

            connect {
                sidecar_service {}
            }
        }

        task "exporter" {
            driver = "docker"

            config {
                image = "prom/statsd-exporter"
            }

            resources {
                cpu    = 50
                memory = 64
            }

            lifecycle {
                hook = "prestart"
                sidecar = true
            }
        }

        service {
            name = "database"
            port = "5432"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                            envoy_stats_tags = ["datacenter=onprem"]
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

        task "database" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.24.2"
            }

            env {
                NAME = "database (onprem)"
                MESSAGE = "25 rows returned"
                LISTEN_ADDR = "0.0.0.0:5432"
                TIMING_VARIANCE = "25"
                HTTP_CLIENT_KEEP_ALIVES = "true"
            }

            resources {
                cpu    = 50
                memory = 64
            }
        }
    }
}
