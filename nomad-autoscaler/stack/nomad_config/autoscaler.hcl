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
    address = "http://{{range $index, $service := service "nomad-client" }}{{if eq $index 0}}{{$service.Address}}:{{$service.Port}}{{end}}{{end}}"
}

apm "prometheus" {
    driver = "prometheus"
    config = {
        address = "http://{{range $index, $service := service "prometheus" }}{{if eq $index 0}}{{$service.Address}}:{{$service.Port}}{{end}}{{end}}"
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