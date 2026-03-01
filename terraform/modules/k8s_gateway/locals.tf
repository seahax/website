locals {
  http_listener_names = [
    for listener in kubernetes_manifest.gateway.manifest.spec.listeners : listener.name
    if listener.protocol == "HTTP"
  ]

  https_listeners = {
    for listener in kubernetes_manifest.gateway.manifest.spec.listeners : listener.hostname => listener.name
    if listener.protocol == "HTTPS"
  }
}
