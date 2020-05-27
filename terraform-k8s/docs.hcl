docs "docs" {
  path  = "./docs"
  port  = 8080
  open_in_browser = true
  
  network {
    name = "network.local"
  }

  # Title for the sidebar
  index_title = "Terraform"

  # id of pages to add to the sidebar
  index_pages = ["index"]
}

container "tools" {
  image   {
    name = "shipyardrun/tools:v0.0.5"
  }
  
  network {
    name = "network.local"
  }

  entrypoint = ["tail", "-f", "/dev/null"]

 # Working files
  volume {
    source      = "./files"
    destination = "/files"
  }
  
  volume {
    source      = "./files/.terraform.d"
    destination = "/root/.terraform.d"
  }

  volume {
    source = "${k8s_config("k3s")}"
    destination = "/root/.kube/config"
  }
}

exec_remote "install_plugin" {
  target = "container.tools"
  cmd = "sh"
  args = ["/files/fetch_plugin.sh"]
}