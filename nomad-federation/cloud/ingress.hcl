// nomad_ingress "nomad-cloud" {
//   cluster  = "nomad_cluster.cloud"
//   job = ""
//   group = ""
//   task = ""
  
//   network {
//     name = "network.wan"
//   }

//   port {
//     local  = 4646
//     remote = 4646
//   }
// }

// nomad_ingress "gateway-cloud" {
//   cluster  = "nomad_cluster.cloud"
//   job = ""
//   group = ""
//   task = ""
  
//   network {
//     name = "network.wan"
//   }

//   port {
//     local  = 443
//     remote = 443
//   }
// }

// nomad_ingress "consul-cloud" {
//   cluster  = "nomad_cluster.cloud"
//   job = ""
//   group = ""
//   task = ""
  
//   network {
//     name = "network.wan"
//   }

//   port {
//     local  = 8500
//     remote = 8500
//   }

//   port {
//     local  = 8300
//     remote = 8300
//   }

//   port {
//     local  = 8302
//     remote = 8302
//   }
// }