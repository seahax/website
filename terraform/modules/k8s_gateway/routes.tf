resource "kubernetes_manifest" "http-to-https-redirect" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${var.name}-http-to-https-redirect"
      namespace = var.namespace
    }

    spec = {
      parentRefs = [for name in local.http_listener_names : {
        name        = kubernetes_manifest.gateway.manifest.metadata.name
        namespace   = var.namespace
        sectionName = name
      }]

      rules = [
        {
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
