docs "docs" {
  path  = "./docs"
  port  = 18080
  open_in_browser = true

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
    name = "network.cloud"
  }
}
