job "autoscaler" {
    datacenters = ["dc1"]
    type = "service"

    group "pool" {
        count = 1

        task "agent" {
            driver = "docker"
            
            template {
                destination = "local/config.hcl"
                data = <<EOH
plugin_dir = "./plugins"
scan_interval = "5s"

nomad {
    address = "http://10.5.0.2:4646"
}

apm "prometheus" {
    driver = "prometheus"
    config = {
        address = "http://10.5.0.2:9090"
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
                cpu    = 100
                memory = 128
            }
        }
    }
}