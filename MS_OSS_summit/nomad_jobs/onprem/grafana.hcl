job "grafana" {
    datacenters = ["onprem"]
    region = "onprem"

    type = "service"

    group "grafana" {
        count = 1

        restart {
            attempts = 2
            interval = "30m"
            delay    = "15s"
            mode     = "fail"
        }

        network {
            mode = "bridge"

            port "http" {
                static = 3000
                to = 3000
            }
        }

        service {
            name = "grafana"
            port = "3000"

            connect {
                sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "prometheus-onprem"
                            local_bind_port = 9090
                        }
                    }
                }
            }
        }

        task "grafana" {
            template {
                left_delimiter = "%%"
                right_delimiter = "%%"
                data = <<EOF
{
  "annotations": {
    "list": [
      {
        "$$hashKey": "object:33",
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "links": [],
  "panels": [
    {
      "cacheTimeout": null,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {},
          "mappings": [
            {
              "$$hashKey": "object:96",
              "id": 0,
              "op": "=",
              "text": "N/A",
              "type": 1,
              "value": "null"
            }
          ],
          "nullValueMode": "connected",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 11,
        "x": 0,
        "y": 0
      },
      "id": 11,
      "interval": null,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "value",
        "fieldOptions": {
          "calcs": [
            "lastNotNull"
          ]
        },
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "values": false
        }
      },
      "pluginVersion": "7.0.0",
      "targets": [
        {
          "expr": "sum(nomad_nomad_job_summary_running{task_group=\"unicorn\"})",
          "interval": "",
          "legendFormat": "{{task_group}}",
          "refId": "A"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Unicorn Instances",
      "type": "stat"
    },
    {
      "cacheTimeout": null,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {},
          "mappings": [
            {
              "$$hashKey": "object:174",
              "id": 0,
              "op": "=",
              "text": "0",
              "type": 1,
              "value": "null"
            }
          ],
          "nullValueMode": "connected",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 11,
        "x": 11,
        "y": 0
      },
      "id": 10,
      "interval": null,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "value",
        "fieldOptions": {
          "calcs": [
            "lastNotNull"
          ]
        },
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "values": false
        }
      },
      "pluginVersion": "7.0.0",
      "targets": [
        {
          "expr": "ceil(sum(rate(envoy_http_downstream_rq_xx{envoy_http_conn_manager_prefix=\"public_listener_http\",local_cluster=\"unicorn\"}[30s])) / sum(nomad_nomad_job_summary_running{task_group=\"unicorn\"}))",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Avg. requests/instance",
      "type": "stat"
    },
    {
      "aliasColors": {
        "0.0.0.0_27214": "purple",
        "0.0.0.0_29970": "red",
        "avg": "red"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 22,
        "x": 0,
        "y": 6
      },
      "hiddenSeries": false,
      "id": 2,
      "legend": {
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "hideZero": true,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null as zero",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "ceil(sum(rate(envoy_http_downstream_rq_xx{envoy_http_conn_manager_prefix=\"public_listener_http\",local_cluster=\"unicorn\"}[30s])) / sum(nomad_nomad_job_summary_running{task_group=\"unicorn\"}) by (datacenter))",
          "hide": false,
          "interval": "",
          "legendFormat": "avg",
          "refId": "A"
        },
        {
          "expr": "ceil(sum(rate(envoy_http_downstream_rq_xx{envoy_http_conn_manager_prefix=\"public_listener_http\",local_cluster=\"unicorn\"}[30s])) by (datacenter))",
          "interval": "",
          "legendFormat": "{{datacenter}}",
          "refId": "B"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Requests",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:111",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:112",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": true,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 22,
        "x": 0,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 13,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": false,
      "linewidth": 1,
      "nullPointMode": "null as zero",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": true,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(rate(envoy_http_downstream_rq_xx{envoy_http_conn_manager_prefix=\"public_listener_http\",envoy_response_code_class=\"2\",local_cluster=\"unicorn\"}[30s])) by (envoy_response_code_class)",
          "interval": "",
          "legendFormat": "2xx",
          "refId": "B"
        },
        {
          "expr": "sum(rate(envoy_http_downstream_rq_xx{envoy_response_code_class=\"5\",local_cluster=\"unicorn\"}[30s])) by (envoy_response_code_class)",
          "instant": false,
          "interval": "",
          "legendFormat": "5xx",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Response Codes",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "refresh": "5s",
  "schemaVersion": 25,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-5m",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ]
  },
  "timezone": "",
  "title": "Cloud Bursting",
  "uid": "8QlvShyZz",
  "version": 1
}
EOF
                destination = "local/dashboard.json"
            }

            template {
                data = <<EOF
- name: 'default'
  org_id: 1
  folder: ''
  type: 'file'
  options:
    folder: '/var/lib/grafana/dashboards'
EOF
                destination = "local/dashboard.yaml"
            }

            template {
                data = <<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  url: http://127.0.0.1:9090
  access: proxy
  isDefault: true
EOF
                destination = "local/datasource.yaml"
            }

            template {
                data = <<EOF
[auth.anonymous]
enabled = true
org_name = "Main Org."
org_role = Editor
EOF
                destination = "local/grafana.ini"
            }

            driver = "docker"

            config {
                image = "grafana/grafana"
                volumes = [
                "local/dashboard.json:/var/lib/grafana/dashboards/default/dashboard.json",
                "local/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml",
                "local/dashboard.yaml:/etc/grafana/provisioning/dashboards/dashboard.yaml",
                "local/grafana.ini:/etc/grafana/grafana.ini"
                ]
            }

            resources {
                cpu    = 100
                memory = 512
            }
        }
    }
}