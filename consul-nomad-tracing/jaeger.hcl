container "jaeger" {
  image   {
    name = "jaegertracing/all-in-one:1.13"
  }

  network {
    name = "network.${var.cn_network}"
    ip_address = "10.15.0.200"
  }

  env_var = {
    COLLECTOR_ZIPKIN_HTTP_PORT = 9411
  }

  port {
    local = 5775
    remote = 5775
  }
  
  port {
    local = 6831
    remote = 6831 
  }
  
  port {
    local = 6832
    remote = 6832
  }
  
  port {
    local = 5778
    remote = 5778
  }
  
  port {
    local = 9411
    remote = 9411
  }
  
  port {
    local = 16686
    remote = 16686
    host = 16686
    open_in_browser="/"
  }
  
  port {
    local = 14268
    remote = 14268
  }
}