# Local network for DC1 cluster
network "dc1" {
  subnet = "10.15.0.0/16"
}

# Local network for DC2 cluster
network "dc2" {
  subnet = "10.16.0.0/16"
}

# WAN network
network "wan" {
  subnet = "192.168.0.0/16"
}