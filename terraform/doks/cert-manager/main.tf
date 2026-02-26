resource "helm_release" "cert-manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.19.3"
  name             = "cert-manager"
  namespace        = "default"
  create_namespace = true
  set = [
    {
      name  = "config.apiVersion"
      value = "controller.config.cert-manager.io/v1alpha1"
    },
    {
      name  = "config.kind"
      value = "ControllerConfiguration"
    },
    {
      name  = "config.enableGatewayAPI"
      value = "true"
    },
    {
      name = "config.enableCertificateOwnerRef"
      value = "true"
    },
    {
      name  = "crds.enabled"
      value = "true"
    },
  ]
}
