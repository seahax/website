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

      listeners = [
        {
          name     = "http"
          hostname = var.hostname
          protocol = "HTTP"
          port     = 80

          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
        },
        {
          name     = "https"
          hostname = var.hostname
          protocol = "HTTPS"
          port     = 443

          allowedRoutes = {
            namespaces = {
              from = "All"
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
      ]
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

  lifecycle {
    prevent_destroy = true
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

variable "hostname" {
  description = "The hostname to use for the gateway listener"
  type        = string
  nullable    = false
}

variable "email" {
  description = "The email address to use for ACME registration"
  type        = string
  nullable    = false
}
