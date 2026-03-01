resource "kubernetes_namespace_v1" "self" {
  metadata {
    name = var.name
    labels = var.labels
    annotations = var.annotations
  }
}
