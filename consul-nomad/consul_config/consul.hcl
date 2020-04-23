data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

config_entries {
  bootstrap = [
    {
      kind = "service-defaults"
      name = "global"
      protocol = "http"
    },
    {
      kind = "proxy-defaults"
      name = "global"
      
      config {
        protocol = "http"

        envoy_extra_static_clusters_json = <<EOL
          {
            "connect_timeout": "3.000s",
            "dns_lookup_family": "V4_ONLY",
            "lb_policy": "ROUND_ROBIN",
            "load_assignment": {
                "cluster_name": "zipkin",
                "endpoints": [
                    {
                        "lb_endpoints": [
                            {
                                "endpoint": {
                                    "address": {
                                        "socket_address": {
                                            "address": "10.15.0.200",
                                            "port_value": 9411,
                                            "protocol": "TCP"
                                        }
                                    }
                                }
                            }
                        ]
                    }
                ]
            },
            "name": "zipkin",
            "type": "STRICT_DNS"
          }
        EOL

        envoy_tracing_json = <<EOL
          {
              "http": {
                  "name": "envoy.zipkin",
                  "config": {
                      "collector_cluster": "zipkin",
                      "collector_endpoint": "/api/v1/spans"
                  }
              }
          }
        EOL
      }
    }
  ]
}
