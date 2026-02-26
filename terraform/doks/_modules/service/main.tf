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

          port {
            container_port = var.port
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

    port {
      port        = var.port
      target_port = var.port
    }
  }
}

resource "kubernetes_manifest" "https" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = var.name
      namespace = var.namespace
    }

    spec = {
      parentRefs = [
        {
          name        = var.gateway
          namespace   = var.namespace
          sectionName = "https"
        }
      ]

      rules = [
        {
          matches = [
            {
              path = {
                type  = var.exact ? "PathExact" : "PathPrefix"
                value = var.path
              }
            }
          ]

          backendRefs = [
            {
              kind      = "Service"
              name      = var.name
              namespace = var.namespace
              port      = var.port
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "http-redirect" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${var.name}-redirect-to-https"
      namespace = var.namespace
    }

    spec = {
      parentRefs = [
        {
          name        = var.gateway
          namespace   = var.namespace
          sectionName = "http"
        }
      ]

      rules = [
        {
          matches = [
            {
              path = {
                type  = var.exact ? "PathExact" : "PathPrefix"
                value = var.path
              }
            }
          ]
          filters = [
            {
              type = "RequestRedirect"

              requestRedirect = {
                scheme     = "https"
                statusCode = 301
              }
            }
          ]
        }
      ]
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

variable "port" {
  description = "The container, pod, and service port."
  type        = number
  nullable    = false
}

variable "path" {
  description = "The HTTP gateway route path prefix for the service."
  type        = string
  nullable    = false
}

variable "exact" {
  description = "Whether to match the HTTP gateway route path exactly or as a prefix."
  type        = bool
  default     = false
}

variable "gateway" {
  description = "The name of the gateway to attach the http route path to."
  type        = string
  default     = "gateway"
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
