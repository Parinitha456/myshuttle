// resource "kubernetes_namespace" "mongo" {
//   metadata {
//     name = "mongo"
//   }
// }
resource "kubernetes_secret" "example2" {
  metadata {
    name = "docker-cfg2"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "latestregistry1.azurecr.io" = {
          "username" = "latestregistry1"
          "password" = "wBGwlPqjOc1ES4uyG7B2DHVo5TkDwqjTeW9QOWl+gG+ACRAkHn3D" 
        }
      }
    })
  }
}
resource "kubernetes_deployment" "db" {
    metadata {
      name      = "db"
      labels = {
        db = "db"
      }
      // namespace = kubernetes_namespace.mongo.metadata.0.name
    }
    spec {
      replicas = 1
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
          image_pull_secrets {
            name = "${kubernetes_secret.example2.metadata.0.name}"
          }
          container {
            image = "latestregistry1.azurecr.io/infraascodeonetouchdeployment_mongo-db:latest"
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