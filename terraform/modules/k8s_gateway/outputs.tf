output "name" {
  value = kubernetes_manifest.gateway.manifest.metadata.name
}

output "https_listeners" {
  value = local.https_listeners
}
