kind = "service-resolver"
name = "unicorn"
failover = {
  "*" = {
    datacenters = ["onprem", "cloud"]
  }
}