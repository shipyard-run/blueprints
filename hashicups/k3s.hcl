cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.0.1"

  nodes = 1 // default

  network = "network.cloud"

  // push images from local docker to k3s on create
  image {
    name = "hashicorpdemoapp/product-api:v0.0.11"
  }
  
  image {
    name = "hashicorpdemoapp/product-api-db:v0.0.11"
  }
  
  image {
    name = "hashicorpdemoapp/frontend:v0.0.3"
  }

  image {
    name = "hashicorpdemoapp/public-api:v0.0.1"
  }

  image {
    name = "jaegertracing/all-in-one:1.13"
  }

  image {
    name = "hashicorp/vault-k8s:0.1.0"
  }
  
  image {
    name = "vault:1.3.1"
  }
  
  image {
    name = "consul:1.6.2"
  }
  
  image {
    name = "hashicorp/consul-k8s:0.9.2"
  }
}
