docs "docs" {
  path  = "./docs"
  port  = 18080

  index_title = "Vault"
  index_pages = [ 
    "index",
    "db",
    "auth",
    "secrets"
  ]

  network {
    name = "network.cloud"
  }
}