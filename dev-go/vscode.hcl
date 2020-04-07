container "vscode" {
  image   {
    name = "shipyardrun/code:go-latest"
  }
  
  network {
    name = "network.local"
  }

  # Add the working files
  volume {
    source      = "./src"
    destination = "/go/src"
  }

 # Add the extension cache
 volume {
   source      = "./extensions"
   destination = "/root/.local/share/code-server/extensions"
 }

 # Add the settings
 volume {
   source = "./config"
   destination = "/root/.local/share/code-server/User"
 }
  
  # Add the Docker sock so Docker CLI in the container
  # can use Docker on the host
  volume {
    source      = "/var/run/docker.sock"
    destination = "/var/run/docker.sock"
  }
  
  # Shipyard home folder
  volume {
    source      = "${env("HOME")}/.shipyard"
    destination = "/root/.shipyard"
  }

  port {
      local  = 8080
      remote = 8080
      host   = 18080
      open_in_browser = "/?folder=/go/src"
  }
  
  env {
    key = "GOPATH"
    value = "/files/go"
  }
}