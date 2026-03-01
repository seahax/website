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
