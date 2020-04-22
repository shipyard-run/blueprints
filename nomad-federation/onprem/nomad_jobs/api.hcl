job "api" {
    datacenters = ["onprem"]
    region = "onprem"
    type = "service"

    group "api" {
        count = 1

        network {
            mode = "bridge"
        }

        service {
            name = "api"
            port = "9090"

            meta {
                datacenter = "onprem"
            }

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                        }
                        
                        upstreams {
                            destination_name = "database"
                            local_bind_port = 5432
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
name = "api"
protocol="http"
EOF

consul config write - <<EOF
kind="service-defaults"
name="api-onprem"
protocol="http"
EOF

consul config write - <<EOF
kind="service-defaults"
name="api-cloud"
protocol="http"
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "api"
failover = {
  "*" = {
    datacenters = ["onprem", "cloud"]
  }
}
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "api-onprem"
redirect {
  service    = "api"
  datacenter = "onprem"
}
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "api-cloud"
redirect {
  service    = "api"
  datacenter = "cloud"
}
EOF

consul config write - <<EOF
kind = "service-splitter"
name = "api"
splits = [
  {
    weight = 50
    service = "api-onprem"
  },
  {
    weight = 50
    service = "api-cloud"
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

        task "api" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.9.0"
            }

            env {
                NAME = "api-onprem"
                MESSAGE = "ok"
                LISTEN_ADDR = "0.0.0.0:9090"
                UPSTREAM_URIS = "http://localhost:5432"
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
