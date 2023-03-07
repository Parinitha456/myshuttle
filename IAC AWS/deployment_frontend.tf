// resource "kubernetes_namespace" "angular" {
//   metadata {
//     name = "angular"
//   }
// }
# resource "kubernetes_secret" "example1" {
#   metadata {
#     name = "docker-cfg1"
#   }

#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#          "oneinsightsregistryy.azurecr.io" = {
#           "username" = "oneinsightsregistryy"
#           "password" = "Ic7FynmG5n5D0UZXC820RN2FWfUA3/=Y"
         
#         }
#       }
#     })
#   }
# }

resource "kubernetes_deployment" "angular" {
    metadata {
      labels = {
        app = "angular"
      }
      name = "bolt"
      // namespace = kubernetes_namespace.angular.metadata.0.name
    }
    spec {
      replicas = 3
      selector {
        match_labels = {
          app = "angular"
        }
      }
      template {
        metadata {
          labels = {
            app = "angular"
          }
        }
        spec {
        #   image_pull_secrets {
        #     name = "${kubernetes_secret.example1.metadata.0.name}"
        #   }
          container {
            image = "vishwavk2021/oneinsights_frontend:latest"
            name  = "bolt"
            image_pull_policy = "Always"
            port {
              container_port = 8080
            }
          }
        }
      }
    }
}
resource "kubernetes_service" "angular" {
    metadata {
      name = "bolt"
    }
    spec {
      selector = {
        app = "angular"
      }
      type = "LoadBalancer"
      port {
        port   = 8080
      }
    }
}