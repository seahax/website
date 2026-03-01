resource "kubernetes_deployment_v1" "self" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }

  spec {
    replicas               = var.replicas
    revision_history_limit = 0

    selector {
      match_labels = {
        deployment = var.name
      }
    }

    template {
      metadata {
        labels = {
          deployment = var.name
        }
      }

      spec {
        container {
          name  = var.name
          image = var.image
          // Restarting pods will always get changes to the tagged image.
          image_pull_policy = "Always"

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.env
            iterator = each

            content {
              name  = each.key
              value = each.value
            }
          }

          dynamic "env_from" {
            for_each = kubernetes_secret_v1.env
            iterator = each

            content {
              secret_ref {
                name = each.value.metadata[0].name
              }
            }
          }
        }

        dynamic "image_pull_secrets" {
          for_each = kubernetes_secret_v1.regcred
          iterator = each

          content {
            name = each.value.metadata[0].name
          }
        }
      }
    }
  }
}
