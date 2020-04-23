job "api" {
    datacenters = ["cloud"]
    region = "cloud"
    type = "service"

    group "api" {
        count = 1

        scaling {
            enabled = true
            min     = 0
            max     = 3

            policy {
                source = "prometheus"
                query  = "scalar(ceil(avg(avg_over_time(envoy_http_downstream_rq_active{envoy_http_conn_manager_prefix=\"public_listener_http\", local_cluster=\"api\"}[30s]))))"

                strategy = {
                    name = "target-value"

                    config = {
                        target = 10
                    }
                }
            }
        }

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

        task "service-defaults" {
            driver = "docker"

            template {
                destination   = "local/central-config.sh"
                data = <<EOH
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

        service {
            name = "api"
            port = "9090"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                            envoy_stats_tags = ["datacenter=cloud"]
                        }
                        
                        upstreams {
                            destination_name = "database"
                            local_bind_port = 5432
                        }
                    }
                }
            }
        }

        task "api" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.9.0"
            }

            env {
                NAME = "api-cloud"
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
