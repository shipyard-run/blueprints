kind           = "service-resolver"
name           = "backend"
default_subset = "v1"
subsets = {
  "v1" = {
    filter = "v1 in Service.Tags"
  }
  "v2" = {
    filter = "v2 in Service.Tags"
  }
}