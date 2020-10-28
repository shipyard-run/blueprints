helm "meshery" {
  cluster = "k8s_cluster.k3s"

  chart = "github.com/layer5io/meshery/install/kubernetes/helm//meshery"

  values_string = {
    "mesheryistio.enabled" = "true"
    "mesheryistio.fullnameOverride" = "meshery-istio"
    "mesherylinkerd.enabled" = "true"
    "mesherylinkerd.fullnameOverride" = "meshery-linkerd"
    "mesheryconsul.enabled" = "true"
    "mesheryconsul.fullnameOverride" = "meshery-consul"
  }
}
  
ingress "meshery" {
  target = "k8s_cluster.k3s"
  service = "svc/meshery"

  port {
    local = 8080
    remote = 8080
    host = 9081
  }
  
  network {
    name = "network.local"
  }
}

ingress "public" {
  target = "k8s_cluster.k3s"
  service = "svc/public"

  port {
    local = 9090
    remote = 9090
    host = 19090
  }
  
  network {
    name = "network.local"
  }
}
