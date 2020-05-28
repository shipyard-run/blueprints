job "autoscaler" {
    datacenters = ["cloud"]
    region = "cloud"
    type = "service"

    group "pool" {
        count = 1

        network {
            mode = "bridge"

            port "http" {
                to = "8080"
            }
        }

        service {
            name = "autoscaler"
            port = "http"

            connect {
                sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "prometheus"
                            local_bind_port = 9090
                        }
                    }
                }
            }
        }

        task "agent" {
            driver = "docker"
            
            template {
                destination = "local/config.hcl"
                data = <<EOH
plugin_dir = "./plugins"
scan_interval = "5s"

nomad {
    address = "http://{{ env "attr.unique.network.ip-address" }}:4646"
    region = "cloud"
}

apm "prometheus" {
    driver = "prometheus"
    config = {
        address = "http://localhost:9090"
    }
}

strategy "target-value" {
    driver = "target-value"
}
                EOH
            }

            config {
                image = "hashicorp/nomad-autoscaler:0.0.1-techpreview2"
                command = "/bin/nomad-autoscaler"
                args = [
                    "agent",
                    "-config=/config.hcl"
                ]
                volumes = ["local/config.hcl:/config.hcl"]
            }

            resources {
                cpu    = 50
                memory = 64
            }
        }
    }
}