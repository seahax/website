resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"

    metadata = {
      namespace = var.namespace
      name      = "${var.name}-issuer"
    }

    spec = {
      acme = {
        server  = "https://acme-v02.api.letsencrypt.org/directory"
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
                    namespace = var.namespace
                    name      = var.name
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
