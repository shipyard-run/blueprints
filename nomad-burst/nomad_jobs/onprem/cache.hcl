job "cache" {
    datacenters = ["onprem"]
    region = "onprem"
    type = "service"

    group "cache" {
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
            name = "cache"
            port = "11211"

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

        task "cache" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.9.0"
            }

            env {
                NAME = "cache (onprem)"
                MESSAGE = "ok"
                LISTEN_ADDR = "0.0.0.0:11211"
                TIMING_VARIANCE = "25"
                HTTP_CLIENT_KEEP_ALIVES = "true"
                TIMING_50_PERCENTILE = "5ms"
            }

            resources {
                cpu    = 50
                memory = 64
            }
        }
    }
}
