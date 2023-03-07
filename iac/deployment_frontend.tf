// resource "kubernetes_namespace" "angular" {
//   metadata {
//     name = "angular"
//   }
// }
resource "kubernetes_secret" "example1" {
  metadata {
    name = "docker-cfg1"
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
resource "kubernetes_deployment" "angular" {
    metadata {
      labels = {
        app = "angular"
      }
      name = "bolt"
      // namespace = kubernetes_namespace.angular.metadata.0.name
    }
    spec {
      replicas = 1
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
            name = "${kubernetes_secret.example1.metadata.0.name}"
          }
          container {
            image = "latestregistry1.azurecr.io/infraascodeonetouchdeployment_frontend:latest"
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