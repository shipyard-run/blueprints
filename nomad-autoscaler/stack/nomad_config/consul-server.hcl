job "consul" {
  datacenters = ["dc1"]
  type = "service"

  group "server" {
    count = 1

    network {
        mode = "bridge"

        port "http" {
            static = 8500
            to = 8500
        }
    }

    task "agent" {
      driver = "docker"

      config {
        image = "consul:1.7.2"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
