terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
  }
}

resource "kubernetes_deployment_v1" "self" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas               = 1
    revision_history_limit = 0

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
        annotations = {
          // Force restarting pods on every apply.
          "kubectl.kubernetes.io/restartedAt" = timestamp()
        }
      }

      spec {
        container {
          name  = var.name
          image = var.image
          // Restarting pods will always get changes to the tagged image.
          image_pull_policy = "Always"

          dynamic "port" {
            for_each = tolist(toset([for port in var.ports : coalesce(port.container_port, port.port)]))
            iterator = each

            content {
              container_port = each.value
            }
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
            for_each = toset(var.env_from_secret)
            iterator = each

            content {
              secret_ref {
                name = each.key
              }
            }
          }
        }

        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secret != "" ? [1] : []

          content {
            name = var.image_pull_secret
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "self" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    dynamic "port" {
      for_each = var.ports
      iterator = each

      content {
        port        = each.value.port
        target_port = coalesce(each.value.container_port, each.value.port)
      }
    }
  }
}

variable "namespace" {
  description = "The namespace to deploy the deployment, service, and route to."
  type        = string
  nullable    = false
}

variable "name" {
  description = "Service name, deployment name, and pod 'app' label."
  type        = string
  nullable    = false
}

variable "replicas" {
  description = "The number of replicas for the deployment."
  type        = number
  nullable    = false
}

variable "image" {
  description = "The container image for the deployment."
  type        = string
  nullable    = false
}

variable "image_pull_secret" {
  description = "The name of the image pull secret to use for the deployment."
  type        = string
  default     = ""
}

variable "ports" {
  description = "The list of ports that are exposed by this service"
  type = list(object({
    port           = number
    container_port = optional(number)
  }))
}

variable "env" {
  description = "Additional environment variables to add to the deployment."
  type        = map(string)
  default     = {}
}

variable "env_from_secret" {
  description = "Secrets to be used as environment variables in the deployment."
  type        = list(string)
  default     = []
}

output "name" {
  value = var.name
}

output "ports" {
  value = [for port in var.ports : port.port]
}
