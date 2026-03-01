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
      port        = local.service_port
      target_port = var.container_port
    }
  }
}
