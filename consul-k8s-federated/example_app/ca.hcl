copy "consul_ca" {
  depends_on = ["module.vms"]

  source      = "${var.cd_consul_data}/cd_consul_ca.cert"
  destination = "${data("certs")}/ca.cert"
}
