resource "kubernetes_manifest" "https" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = var.name
      namespace = var.namespace
    }

    spec = {
      parentRefs = [for listener in var.listeners : {
        name        = var.gateway
        namespace   = var.namespace
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
              name      = kubernetes_service_v1.self.metadata[0].name
              namespace = var.namespace
              port      = local.service_port
            }
          ]
        }
      ]
    }
  }
}

# resource "kubernetes_manifest" "http-redirect" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "HTTPRoute"

#     metadata = {
#       name      = "${var.name}-redirect-to-https"
#       namespace = var.namespace
#     }

#     spec = {
#       parentRefs = [{
#         name        = var.gateway
#         namespace   = var.namespace
#         sectionName = "http-${var.listener}"
#       }]

#       rules = [
#         {
#           matches = [
#             {
#               path = {
#                 type  = var.exact ? "PathExact" : "PathPrefix"
#                 value = var.path
#               }
#             }
#           ]
#           filters = [
#             {
#               type = "RequestRedirect"

#               requestRedirect = {
#                 scheme     = "https"
#                 statusCode = 301
#               }
#             }
#           ]
#         }
#       ]
#     }
#   }
# }
