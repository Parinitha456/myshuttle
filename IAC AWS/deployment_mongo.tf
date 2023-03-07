// resource "kubernetes_namespace" "mongo" {
//   metadata {
//     name = "mongo"
//   }
// }
# resource "kubernetes_secret" "example2" {
#   metadata {
#     name = "docker-cfg2"
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

resource "kubernetes_deployment" "db" {
    metadata {
      name      = "db"
      labels = {
        db = "db"
      }
      // namespace = kubernetes_namespace.mongo.metadata.0.name
    }
    spec {
      replicas = 3
      selector {
        match_labels = {
          db = "db"
        }
      }
      template {
        metadata {
          labels = {
            db = "db"
          }
        }
        spec {
        #   image_pull_secrets {
        #     name = "${kubernetes_secret.example2.metadata.0.name}"
        #   }
          container {
            image = "vishwavk2021/oneinsights_mongo:latest"
            name  = "db"
            port {
              container_port = 27017
            }
          }
        }
      }
    }
  }
resource "kubernetes_service" "db" {
  metadata {
    labels = {
      db = "db"
    }
    name = "db"
  }
  spec {
    selector = {
      db = "db"
    }
    type = "LoadBalancer"
    port {
      name = "mongo-port"
      port   = 27017
    }
  }
}