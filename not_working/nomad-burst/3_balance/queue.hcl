job "queue" {
    datacenters = ["cloud"]
    region = "cloud"
    type = "service"

    group "queue" {
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
            name = "queue"
            port = "25672"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                            envoy_stats_tags = ["datacenter=cloud"]
                        }
                    }
                }
            }
        }

        task "queue" {
            driver = "docker"

            config {
                image = "nicholasjackson/fake-service:v0.24.2"
            }

            env {
                NAME = "queue (cloud)"
                MESSAGE = "ok"
                LISTEN_ADDR = "0.0.0.0:25672"
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
