docs "docs" {
  path  = "./docs"
  port  = 18080
  open_in_browser = true
  
  network {
    name = "network.onprem"
  }

  # Title for the sidebar
  index_title = "Consul"

  # id of pages to add to the sidebar
  index_pages = ["index"]
}