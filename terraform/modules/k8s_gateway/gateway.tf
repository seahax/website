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

      listeners = flatten([for hostname in var.hostnames : [
        {
          name     = "http-${sha256(hostname)}"
          hostname = hostname
          protocol = "HTTP"
          port     = 80
        },
        {
          name     = "https-${sha256(hostname)}"
          hostname = hostname
          protocol = "HTTPS"
          port     = 443

          tls = {
            mode = "Terminate"

            certificateRefs = [
              {
                kind = "Secret"
                name = "${var.name}-tls-certificate"
              }
            ]
          }
        }
      ]])
    }
  }
}
