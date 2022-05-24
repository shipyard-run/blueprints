# Register the node and service for the database with consul
exec_remote "register_service" {

  depends_on = ["module.nomad_consul"]

  image {
    name = "consul:1.12.0"
  }

  network {
    name = "network.dc1"
  }

  #command = ["tail","-f","/dev/null"]
  cmd = "/scripts/register_mysql.sh"

  //cmd = "/bin/sh"
  //args = [
  //  "-c",
  //  <<EOF
  //    sleep 10 && \
  //    curl -XPUT -d @/config/mysql_svc.json http://consul.container.shipyard.run:8500/v1/catalog/register
  //  EOF
  //]

  volume {
    source      = "./scripts"
    destination = "/scripts"
  }

  volume {
    source      = "./consul_config/mysql_svc.json"
    destination = "/config/mysql_svc.json"
  }

  env_var = {
    CONSUL_HTTP_ADDR = "http://consul.container.shipyard.run:8500"
  }
}

container "database" {
  network {
    name       = "network.database"
    ip_address = "10.20.0.50"
  }

  image {
    name = "nicholasjackson/fake-service:v0.14.1"
  }

  env {
    key   = "LISTEN_ADDR"
    value = ":3306"
  }

  env {
    key   = "NAME"
    value = "database"
  }
}
