// resource "kubernetes_namespace" "springboot" {
//   metadata {
//     name = "springboot"
//   }
// }
# resource "kubernetes_secret" "example3" {
#   metadata {
#     name = "docker-cfg3"
#   }

#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#         "oneinsightsregistryy.azurecr.io" = {
#           "username" = "oneinsightsregistryy"
#           "password" = "Ic7FynmG5n5D0UZXC820RN2FWfUA3/=Y"
          
#         }
#       }
#     })
#   }
# }

resource "kubernetes_deployment" "springboot" {
    metadata {
      labels = {
        app = "springboot"
      }
      name = "sprbackend"
    }
    spec {
      replicas = 3
      selector {
        match_labels = {
          app = "springboot"
        }
      }
      template {
        metadata {
          labels = {
            app = "springboot"
          }
        }
        spec {
        #   image_pull_secrets {
        #     name = "${kubernetes_secret.example3.metadata.0.name}"
        #   }
          container {
            image = "vishwavk2021/oneinsights_backend:latest"
            name  = "sprbackend"
            port {
              container_port = 8082
            }
          }
        }
      }
    }
}
resource "kubernetes_service" "springboot" {
    metadata {
      name      = "sprbackend"
    }
    spec {
      selector = {
        app = "springboot"
      }
      type = "LoadBalancer"
      port {
        port   = 8082
      }
    }
}