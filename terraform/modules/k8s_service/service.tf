resource "kubernetes_service_v1" "self" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }

  spec {
    selector = {
      deployment = kubernetes_deployment_v1.self.spec[0].template[0].metadata[0].labels["deployment"]
    }

    port {
      port        = local.service_port
      target_port = kubernetes_deployment_v1.self.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}
