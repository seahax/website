output "name" {
  value = kubernetes_namespace_v1.self.metadata[0].name
}
