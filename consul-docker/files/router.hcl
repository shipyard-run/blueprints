kind = "service-router"
name = "backend"
routes = [
  {
    match {
      http {
        query_param = [
          {
            name  = "x-version"
            exact = "1"
          },
        ]
      }
    }
    destination {
      service        = "backend"
      service_subset = "v1"
    }
  },
  {
    match {
      http {
        header = [
          {
            name  = "x-version"
            exact = "2"
          },
        ]
      }
    }
    destination {
      service        = "backend"
      service_subset = "v2"
    }
  }
]