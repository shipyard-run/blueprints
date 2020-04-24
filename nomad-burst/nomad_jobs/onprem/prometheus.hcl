job "monitoring" {
    datacenters = ["onprem"]
    region = "onprem"

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
            port = "9090"

            connect {
                sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "prometheus-cloud"
                            local_bind_port = 9091
                        }
                    }
                }
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
      services: ['exporter']

  - job_name: federation
    honor_labels: true
    metrics_path: /federate
    params:
      'match[]':
      - '{job="exporter"}'
      - '{datacenter="cloud"}'
    static_configs:
    - targets:
      - 'localhost:9091'

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