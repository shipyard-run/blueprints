kind = "service-splitter"
name = "api"
splits = [
  {
    weight = 50
    ServiceSubset = "v1"
  },
  {
    weight = 50
    ServiceSubset = "v2"
  },
]