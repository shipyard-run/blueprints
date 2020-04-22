job "monitoring" {
    datacenters = ["onprem"]
    region = "onprem"

    group "exporter" {
        count = 1

        network {
            mode = "bridge"
            
            port "statsd" {
                static = 9125
                to = 9125
            }

            port "prometheus" {
                static = 9102
                to = 9102
            }
        }

        service {
            name = "exporter-statsd"
            port = "statsd"

            connect {
                sidecar_service {}
            }
        }

        service {
            name = "exporter-prometheus"
            port = "prometheus"

            connect {
                sidecar_service {}
            }
        }

        task "service-defaults" {
            driver = "docker"

            template {
                destination   = "local/central-config.sh"
                data = <<EOH
consul config write - <<EOF
kind = "service-defaults"
name = "exporter-statsd"
protocol="http"
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "exporter-statsd"
redirect {
service    = "exporter-statsd"
datacenter = "onprem"
}
EOF

consul config write - <<EOF
kind = "service-defaults"
name = "exporter-prometheus"
protocol="http"
EOF

consul config write - <<EOF
kind = "service-resolver"
name = "exporter-prometheus"
redirect {
service    = "exporter-prometheus"
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

        task "exporter" {
            driver = "docker"

            config {
                image = "prom/statsd-exporter"
            }

            resources {
                cpu    = 50
                memory = 64
            }
        }
    }

    group "prometheus" {
        count = 1

        network {
            mode = "bridge"

            port "http" {
                static = 9090
                to = 9090
            }
        }

        service {
            name = "prometheus"
            port = "http"

            connect {
                sidecar_service {}
            }
        }

        task "prometheus" {
            template {
                destination = "local/prometheus.yml"
                data = <<EOH
---
global:
  scrape_interval:     1s
  evaluation_interval: 1s

scrape_configs:
  - job_name: exporter
    consul_sd_configs:
    - server: '{{ env "attr.unique.network.ip-address" }}:8500'
      services: ['exporter-prometheus']

  - job_name: consul
    metrics_path: /v1/agent/metrics
    params:
      format: ['prometheus']
    static_configs:
    - targets: ['{{ env "attr.unique.network.ip-address" }}:8500']

  - job_name: nomad
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']
    static_configs:
    - targets: ['{{ env "attr.unique.network.ip-address" }}:4646']
EOH
            }

            driver = "docker"

            config {
                image = "prom/prometheus:latest"
                volumes = [
                "local/prometheus.yml:/etc/prometheus/prometheus.yml",
                ]
            }

            resources {
                cpu = 100
                memory = 512
            }
        }
    }
}