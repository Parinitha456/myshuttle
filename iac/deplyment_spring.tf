// resource "kubernetes_namespace" "springboot" {
//   metadata {
//     name = "springboot"
//   }
// }
resource "kubernetes_secret" "example3" {
  metadata {
    name = "docker-cfg3"
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
resource "kubernetes_deployment" "springboot" {
    metadata {
      labels = {
        app = "springboot"
      }
      name = "sprbackend"
    }
    spec {
      replicas = 1
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
          image_pull_secrets {
            name = "${kubernetes_secret.example3.metadata.0.name}"
          }
          container {
            image = "latestregistry1.azurecr.io/infraascodeonetouchdeployment_java-api:latest"
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