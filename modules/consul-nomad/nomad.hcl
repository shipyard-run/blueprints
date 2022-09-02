template "nomad_config" {
  source = <<-EOF
  client {
    #{{ if ne .Vars.name "" }}
    host_volume "#{{ .Vars.name }}" {
      path = "#{{ .Vars.path }}"
    }
    #{{ end }}
  }
  EOF

  vars = {
    name = var.cn_nomad_client_host_volume.name
    path = var.cn_nomad_client_host_volume.destination
  }

  destination = "${data("nomad_config")}/client.hcl"
}

template "consul_agent_config" {
  source      = var.cn_consul_agent_config
  destination = "${data("consul_config")}/agent.hcl"

  vars = {
    datacenter    = var.cn_consul_datacenter
    consul_server = var.cn_consul_cluster_name
  }
}

template "docker_registries" {
  source = <<-EOF
  {
    "insecure-registries" : [ 
      #{{range $index, $val := .Vars.registries}}
      #{{if $index}},#{{- end}}
      "#{{$val}}"
      #{{- end}}
    ]
  }
  EOF

  vars = {
    registries = var.cn_nomad_docker_insecure_registries
  }
  // /etc/docker/daemon.json
  destination = "${data("nomad_config")}/daemon.json"
}

nomad_cluster "local" {
  depends_on = ["module.consul", "template.consul_agent_config", "template.nomad_config"]

  version      = var.cn_nomad_version
  client_nodes = var.cn_nomad_client_nodes

  network {
    name       = "network.${var.cn_network}"
    ip_address = var.cn_nomad_client_nodes == 0 ? var.cn_nomad_server_ip : ""
  }

  consul_config = var.cn_nomad_consul_agent_config
  client_config = var.cn_nomad_client_config
  server_config = var.cn_nomad_server_config

  open_in_browser = var.cn_nomad_open_browser

  image {
    name = var.cn_nomad_load_image
  }

  # Add a host volume to the Nomad client if the user has specified one.
  # if no host volume is specified, the Nomad client will not be able to
  volume {
    source      = var.cn_nomad_client_host_volume.source
    destination = var.cn_nomad_client_host_volume.destination
    type        = var.cn_nomad_client_host_volume.type
  }

  # Add the Docker daemon config for insecure registries
  volume {
    source      = "${data("nomad_config")}/daemon.json"
    destination = "/etc/docker/daemon.json"
  }
}
