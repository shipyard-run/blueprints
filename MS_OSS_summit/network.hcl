network "wan" {
    subnet = "192.168.0.0/16"
}

network "onprem" {
  subnet = "10.5.0.0/16"
}

network "cloud" {
  subnet = "10.10.0.0/16"
}