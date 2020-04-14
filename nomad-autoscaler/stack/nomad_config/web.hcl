job "web" {
  datacenters = ["dc1"]

  group "proxy" {
    count = 1

    network {
        mode = "bridge"

        port "http" {
            static = 80
            to = 80
        }

        port "ui" {
            static = 1936
            to = 1936
        }

        port "exporter" {
            static = 9101
            to = 9101
        }
    }

    service {
        name = "haproxy"
        port = "ui"

        check {
          name     = "haproxy alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
    }

    service {
        name = "exporter"
        port = "exporter"

        check {
          name     = "haproxy_exporter port alive"
          type     = "http"
          path     = "/metrics"
          interval = "10s"
          timeout  = "2s"
        }

        connect {
            sidecar_service {}
        }
    }

    service {
        name = "web"
        port = "http"

        connect {
            sidecar_service {
                proxy {
                    config {
                        envoy_dogstatsd_url = "udp://10.5.0.2:9125" 
                    }

                    upstreams {
                        destination_name = "api"
                        local_bind_port = 9091
                    }
                }
            }
        }
    }

    task "haproxy" {
      driver = "docker"

      config {
        image = "haproxy:2.0"

        volumes = [
          "local/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg",
        ]
      }

      template {
        data = <<EOF
defaults
   mode http

frontend stats
   bind *:1936
   stats uri /
   stats show-legends
   no log

frontend http_front
   bind 0.0.0.0:80
   default_backend http_back

backend http_back
    balance roundrobin
    default-server check
    server api localhost:9091
EOF

        destination = "local/haproxy.cfg"
        change_mode = "restart"
      }

      resources {
        cpu    = 100
        memory = 512

        network {
          mbits = 10
        }
      }
    }

    task "haproxy_prometheus" {
      driver = "docker"

      config {
        image = "prom/haproxy-exporter"

        args = ["--haproxy.scrape-uri", "http://localhost:${NOMAD_PORT_ui}/?stats;csv"]

        port_map {
          http = 9101
        }
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          mbits = 10
        }
      }
    }
  }
}