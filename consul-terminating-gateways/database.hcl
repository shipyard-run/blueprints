# Register the node and service for the database with consul
exec_remote "exec_container" {
  target = var.cn_consul_cluster_name

  cmd = "/bin/sh"
  args = [
    "-c",
    <<EOF
      sleep 10 && \
      curl -XPUT -d @/config/mysql_svc.json localhost:8500/v1/catalog/register
    EOF
  ]
}

container "database" {
    network {
      name = "network.database"
      ip_address = "10.20.0.50"
    }

    image {
        name = "nicholasjackson/fake-service:v0.14.1"
    }
 
    env {
      key = "LISTEN_ADDR"
      value = ":3306"
    }
   
    env {
      key = "NAME"
      value = "database"
    }
}
