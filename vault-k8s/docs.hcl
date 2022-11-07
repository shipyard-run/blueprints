docs "docs" {
  path  = "./docs"
  port  = 18080
  open_in_browser = true

  image {
    name = "shipyardrun/docs:v0.6.0"
  }

  index_title = "Vault"
  index_pages = [ 
    "index",
    "auth",
    "static",
    "db",
    "secrets",
    "x509",
    "transit"

  ]

  network {
    name = "network.dc1"
  }
}
