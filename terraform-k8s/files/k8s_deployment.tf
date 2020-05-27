variable "replicas" {
  default = 3
  type = number
}


provider "kubernetes-alpha" {
 server_side_planning = true
}

/*
resource "kubernetes_manifest" "web-service" {
 provider = kubernetes-alpha


  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/managed-by" = "Terraform"
      }
      "name"      = "web-service"
      "namespace" = "default"
    }
    "spec" = {
      "ports" = [
        {
          "port"       = 443
          "targetPort" = "http"
          "protocol"   = "TCP"
        },
      ]
      "selector" = {
        "app" = "nginx"
      }
    }
  }
}
*/

resource "kubernetes_manifest" "nginx" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "nginx"
      }
      "name"      = "nginx-deployment"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = var.replicas
      "selector" = {
        "matchLabels" = {
          "app" = "nginx"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "nginx"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx:1.14.2"
              "name"  = "nginx"
              "ports" = [
                {
                  "containerPort" = 80
                  "protocol"      = "TCP"
                },
              ]
            },
          ]
        }
      }
    }
  }

}