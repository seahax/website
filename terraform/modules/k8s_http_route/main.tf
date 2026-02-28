terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
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
      parentRefs = [{
        name        = var.gateway
        namespace   = var.namespace
        sectionName = "https-${var.listener}"
      }]

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
              name      = var.service_name
              namespace = var.namespace
              port      = var.service_port
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
      parentRefs = [{
        name        = var.gateway
        namespace   = var.namespace
        sectionName = "http-${var.listener}"
      }]

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
  description = "The namespace to deploy the route to."
  type        = string
  nullable    = false
}

variable "name" {
  description = "The name of the route."
  type        = string
  nullable    = false
}

variable "path" {
  description = "The path prefix for the route."
  type        = string
  nullable    = false
}

variable "exact" {
  description = "Whether to match the path exactly or as a prefix."
  type        = bool
  default     = false
}

variable "gateway" {
  description = "The name of the gateway to attach the route to."
  type        = string
  default     = "gateway"
}

variable "listener" {
  description = "The gateway listener name to attach the route to."
  type        = string
  nullable    = false
}

variable "service_name" {
  description = "The backend service name to route to."
  type        = string
  nullable    = false
}

variable "service_port" {
  description = "The backend service port to route to."
  type        = number
  nullable    = false
}
