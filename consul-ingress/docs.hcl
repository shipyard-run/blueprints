docs "docs" {
  path  = "./docs"
  port  = 18080
  
  network {
    name = "network.onprem"
  }

  # Title for the sidebar
  index_title = "Consul"

  # id of pages to add to the sidebar
  index_pages = ["index"]
}