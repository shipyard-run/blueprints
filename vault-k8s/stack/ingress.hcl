ingress "vault-http" {
  target = "cluster.k3s"
  service  = "svc/vault"

  port {
    local  = 8200
    remote = 8200
    host   = 18200
  }
}

ingress "k8s-dashboard" {
  target = "cluster.k3s"
  service = "svc/kubernetes-dashboard"
  namespace = "kubernetes-dashboard"

  port {
    local = 8443
    remote = 8443
    host = 18443
  }
}