job "order" {
    datacenters = ["cloud"]
    region = "cloud"
    type = "batch"

    group "order" {
        count = 0

        network {
            mode = "bridge"

            port "prometheus" {
                to = "9102"
            }
        }

        scaling {
            enabled = true
            min     = 0
            max     = 5

            policy {
                source = "prometheus"
                query  = "scalar(5 - sum(nomad_nomad_job_summary_running{task_group=\"order\"}) - sum(nomad_nomad_job_summary_running{task_group=\"unicorn\"}))"

                strategy = {
                    name = "target-value"

                    config = {
                        target = 1
                    }
                }
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
            name = "order"
            port = "3000"

            connect {
                sidecar_service {
                    proxy {
                        config {
                            envoy_dogstatsd_url = "udp://127.0.0.1:9125"
                            envoy_stats_tags = ["datacenter=cloud"]
                        }

                        upstreams {
                            destination_name = "queue"
                            local_bind_port = 25672
                        }

                        upstreams {
                            destination_name = "database"
                            local_bind_port = 5432
                        }
                    }
                }
            }
        }

        task "order" {
            driver = "docker"

            template {
                data = <<EOF
echo "Initializing"
sleep 2
echo "Grabbing work from the queue"
curl -s localhost:25672
sleep 2
echo "Storing processed order in the database"
curl -s localhost:5432
sleep 2
echo "Cleaning up"
sleep 2
EOF
                destination = "local/batch.sh"
            }

            config {
                image = "curlimages/curl"
                command = "sh"
                args = ["local/batch.sh"]
            }

            resources {
                cpu    = 50
                memory = 32
            }
        }
    }
}
