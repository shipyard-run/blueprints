kind = "service-splitter"
name = "unicorn"
splits = [
  {
    weight = 50
    service = "unicorn-onprem"
  },
  {
    weight = 50
    service = "unicorn-cloud"
  },
]