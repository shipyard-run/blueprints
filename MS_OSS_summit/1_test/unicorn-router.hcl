kind = "service-router"
name = "unicorn"
routes = [
  {
    match {
      http {
        header = [
          {
            name  = "X-Group"
            exact = "test"
          },
        ]
      }
    }

    destination {
      service = "unicorn-cloud"
    }
  },
]