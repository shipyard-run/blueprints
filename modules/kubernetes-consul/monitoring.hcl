module "monitoring" {
  depends_on = ["helm.consul"]
  disabled   = var.consul_monitoring_enabled == false
  source     = "github.com/shipyard-run/blueprints?ref=296b620ba7dfcf1ed0a29b84d04ff30fdcf81210/modules//kubernetes-monitoring"
  #source = "../kubernetes-monitoring"
}

template "consul_proxy_defaults" {
  source      = file("./config/proxy-defaults.yaml")
  destination = "${var.consul_data_folder}/proxy-defaults.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

k8s_config "consul_defaults" {
  depends_on = ["helm.consul", "template.consul_proxy_defaults"]
  disabled   = var.consul_monitoring_enabled == false

  cluster = "k8s_cluster.${var.consul_k8s_cluster}"
  paths = [
    "${var.consul_data_folder}/proxy-defaults.yaml"
  ]

  wait_until_ready = false
}

template "monitor_ingress_gateway" {
  disabled   = var.consul_monitoring_enabled == false || var.consul_ingress_gateway_enabled == false
  depends_on = ["module.monitoring"]

  source = <<EOF
  # ServiceMonitor to configure Prometheus to scrape metrics from applications in the consul namespace
  ---
  apiVersion: monitoring.coreos.com/v1
  kind: ServiceMonitor
  metadata:
    labels:
      release: prometheus
    name: ingress-gateway
    namespace: #{{ .Vars.monitoring_namespace }}
  spec:
    endpoints:
    - interval: 15s
      port: metrics
    jobLabel: ingress-gateway
    namespaceSelector:
      matchNames:
      - consul
    selector:
      matchLabels:
        app: metrics
  
  # Service to configure Prometheus to scrape metrics from the ingress-gateway in the consul namespace
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: ingress-gateway-metrics
    namespace: #{{ .Vars.consul_namespace }}
    labels:
      app: metrics
  spec:
    selector:
      component: ingress-gateway
    ports:
      - name: metrics
        protocol: TCP
        port: 20200
        targetPort: 20200
  EOF

  destination = "${var.consul_data_folder}/ingress-service-monitor.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
    consul_namespace     = var.consul_namespace
  }
}

k8s_config "monitor_ingress_gateway" {
  disabled   = var.consul_monitoring_enabled == false || var.consul_ingress_gateway_enabled == false
  depends_on = ["template.monitor_ingress_gateway"]

  cluster = "k8s_cluster.${var.consul_k8s_cluster}"
  paths = [
    "${var.consul_data_folder}/ingress-service-monitor.yaml",
  ]

  wait_until_ready = true
}