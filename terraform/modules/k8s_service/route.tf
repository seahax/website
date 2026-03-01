resource "kubernetes_manifest" "https" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      namespace = var.namespace
      name      = var.name
    }

    spec = {
      parentRefs = [for listener in var.listeners : {
        namespace   = var.namespace
        name        = var.gateway
        sectionName = listener
      }]

      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = var.prefix
              }
            }
          ]

          backendRefs = [
            {
              kind      = "Service"
              namespace = var.namespace
              name      = kubernetes_service_v1.self.metadata[0].name
              port      = kubernetes_service_v1.self.spec[0].port[0].port
            }
          ]
        }
      ]
    }
  }
}
