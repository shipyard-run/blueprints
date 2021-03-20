container "consul" {
  image   {
    name = "consul:1.8.0"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source = "./consul_config"
    destination = "/config"
  }

  network {
    name = "network.cloud"
  }

  port {
    local = 8500
    remote = 8500
    host = 8500
  }

  health_check {
    http = "http://consul.container.shipyard.run:8500/v1/status/leader"
    timeout = "10s"
  }
}

exec_remote "exec_container" {
  target = "container.consul"
  cmd = "/bin/sh"
  args = [
    "-c",
    <<EOF
      sleep 10 && \
      curl -XPUT -d @/config/mysql_svc.json localhost:8500/v1/catalog/register
    EOF
  ]
}