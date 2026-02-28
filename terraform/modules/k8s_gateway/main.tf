terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
  }
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = var.name
      namespace = var.namespace

      annotations = {
        "service.beta.kubernetes.io/do-loadbalancer-tls-passthrough" = "true"
        "cert-manager.io/issuer"                                     = kubernetes_manifest.issuer.manifest.metadata.name
      }
    }

    spec = {
      gatewayClassName = "cilium"

      infrastructure = {
        annotations = {
          "service.beta.kubernetes.io/do-loadbalancer-name"      = var.loadbalancer_name
          "service.beta.kubernetes.io/do-loadbalancer-size-unit" = var.loadbalancer_size
        }
      }

      listeners = flatten([for name, listener in var.listeners : [
        {
          name     = "http-${name}"
          hostname = listener.hostname
          protocol = "HTTP"
          port     = 80

          allowedRoutes = {
            namespaces = {
              from = var.shared ? "All" : "Same"
            }
          }
        },
        {
          name     = "https-${name}"
          hostname = listener.hostname
          protocol = "HTTPS"
          port     = 443

          allowedRoutes = {
            namespaces = {
              from = var.shared ? "All" : "Same"
            }
          }

          tls = {
            mode = "Terminate"

            certificateRefs = [
              {
                kind = "Secret"
                name = "${var.name}-tls"
              }
            ]
          }
        }
      ]])
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"

    metadata = {
      name      = "${var.name}-issuer"
      namespace = var.namespace
    }

    spec = {
      acme = {
        server  = "https://acme-v02.api.letsencrypt.org/directory"
        email   = var.email
        profile = "tlsserver"

        privateKeySecretRef = {
          name = "${var.name}-issuer-acme-private-key"
        }

        solvers = [
          {
            http01 = {
              gatewayHTTPRoute = {
                parentRefs = [
                  {
                    kind      = "Gateway"
                    name      = var.name
                    namespace = var.namespace
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}

variable "namespace" {
  description = "The namespace to deploy the gateway into"
  type        = string
  nullable    = false
}

variable "name" {
  description = "The name of the gateway"
  type        = string
  default     = "gateway"
}

variable "loadbalancer_name" {
  description = "The name of the loadbalancer created by the Gateway"
  type        = string
  default     = null
}

variable "loadbalancer_size" {
  description = "The number of load balancer instances"
  type        = number
  default     = 1
}

variable "listeners" {
  description = "The listeners to create on the gateway"
  type = map(object({
    hostname = string
  }))
  nullable = false
}

variable "email" {
  description = "The email address to use for ACME registration"
  type        = string
  nullable    = false
}

variable "shared" {
  description = "If true, allow routes in any namespace to attach to listeners"
  type        = bool
  default     = false
}
