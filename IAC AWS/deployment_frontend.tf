resource "kubernetes_secret" "example1" {
  metadata {
    name = "docker-cfg2"
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
resource "kubernetes_deployment" "angular" {
    metadata {
      labels = {
        app = "angular"
      }
      name = "myshuttle"
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
            image = "vkmyshuttlesample.azurecr.io/web:latest"
            name  = "myshuttle"
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
      name = "myshuttle"
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