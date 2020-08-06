kind = "service-splitter"
name = "backend"
splits = [
  {
    weight         = 10
    service_subset = "v1"
  },
  {
    weight         = 90
    service_subset = "v2"
  },
]