//
// Create a network for the Kubernetes cluster.
//
network "dc1" {
  subnet = "10.5.0.0/16"
}

//
// Create a single node Kubernetes cluster.
//
k8s_cluster "dc1" {
  driver  = "k3s"
  version = "v1.0.1"

  nodes = 1

  network {
    name = "network.dc1"
  }

  image {
    name = "hashicorpdev/consul"
  }
}

//
// Install Consul using the helm chart.
//
helm "consul" {
  cluster = "k8s_cluster.dc1"

  // chart = "github.com/hashicorp/consul-helm?ref=crd-controller-base"
  chart = "github.com/hashicorp/consul-helm?ref=d3dd318f0d194f0147d73b35bf86a2ec028b277c"
  values = "./helm/consul-values.yaml"

  health_check {
    timeout = "60s"
    pods = ["app=consul"]
  }
}


//
// Deploy the application stack and jaeger for tracing.
//
k8s_config "dc1" {
  cluster = "k8s_cluster.dc1"
  depends_on = ["helm.consul"]

  paths = [
    "./k8s_config/web.yaml",
    "./k8s_config/api-v1.yaml",
    "./k8s_config/api-v2.yaml",
    "./k8s_config/jaeger.yaml"
  ]

  wait_until_ready = true
}