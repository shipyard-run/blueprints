job "unicorn" {
    datacenters = ["onprem"]
    region = "onprem"
    type = "service"

    group "unicorn" {
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
            name = "unicorn"
            port = "3000"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                            envoy_stats_tags = ["datacenter=onprem"]
                        }

                        upstreams {
                            destination_name = "cache"
                            local_bind_port = 11211
                        }
                        
                        upstreams {
                            destination_name = "database"
                            local_bind_port = 5432
                        }
                    }
                }
            }
        }

        task "unicorn" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.9.0"
            }

            env {
                NAME = "unicorn (onprem)"
                MESSAGE = "ok"
                LISTEN_ADDR = "0.0.0.0:3000"
                UPSTREAM_URIS = "http://localhost:11211,http://localhost:5432"
                TIMING_VARIANCE = "25"
                HTTP_CLIENT_KEEP_ALIVES = "true"
                UPSTREAM_WORKERS = "2"
                RATE_LIMIT = "20"
                TIMING_50_PERCENTILE = "50ms"
            }

            resources {
                cpu    = 50
                memory = 64
            }
        }
    }
}
