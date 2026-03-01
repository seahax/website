module "gateway" {
  source            = "../../modules/k8s_gateway"
  namespace         = kubernetes_namespace_v1.self.metadata[0].name
  name              = "seahax"
  loadbalancer_name = "seahax-k8s-gateway"
  hostnames         = ["api.seahax.com", "auth.seahax.com"]
}
