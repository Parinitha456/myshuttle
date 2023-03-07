resource "kubernetes_secret" "example1" {
  metadata {
    name = "docker-cfg1"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "vkmyshuttlesample.azurecr.io" = {
          "username" = "vkmyshuttlesample"
          "password" = "QZKZ2XcxxxcoLAEhhrsE1CS81LbgilS8a71uXGqm7P+ACRAHmqBb"
          
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
            image = "vkmyshuttlesample.azurecr.io/db:latest"
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