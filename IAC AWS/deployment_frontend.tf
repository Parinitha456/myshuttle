resource "kubernetes_secret" "example2" {
  metadata {
    name = "docker-cfg2"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "vkmyshuttlesample1.azurecr.io" = {
          "username" = "vkmyshuttlesample1"
          "password" = "8BsQkjH55yOkZi+gfnCONIIVPXNOMsrt1T1M5ryBNt+ACRAaOzdR"
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
          image_pull_secrets {
               name = "${kubernetes_secret.example2.metadata.0.name}"
             }
          container {
            image = "vkmyshuttlesample1.azurecr.io/web:latest"
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