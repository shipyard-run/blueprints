k8s_cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.0.0"

  nodes = 1 // default

/*
  image {
    // Image is from a private repository so need to add credentials
    name     = "docker.pkg.github.com/nicholasjackson/demo-vault/vault-k8s:0.1.0"
    username = "${env("GITHUB_USER")}"
    password = "${env("GITHUB_TOKEN")}"
  }

  image {
    // Image is from a private repository so need to add credentials
    name     = "docker.pkg.github.com/nicholasjackson/demo-vault/vault:1.3.1"
    username = "${env("GITHUB_USER")}"
    password = "${env("GITHUB_TOKEN")}"
  }
*/

  network {
    name = "network.cloud"
  }
}
