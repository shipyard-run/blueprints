job "api" {
    datacenters = ["cloud"]
    region = "cloud"
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
                datacenter = "cloud"
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
