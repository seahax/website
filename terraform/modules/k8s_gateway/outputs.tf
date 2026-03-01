output "name" {
  value = kubernetes_manifest.gateway.manifest.metadata.name
}

output "listeners" {
  description = "Map of listener names (aka: HTTPRoute spec.parentRef[].sectionName). Only includes HTTPS listeners. HTTP listeners are only used internally to redirect to HTTPS."
  value       = local.https_listeners
}
