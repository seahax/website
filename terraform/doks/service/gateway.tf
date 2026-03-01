module "gateway" {
  source            = "../../modules/k8s_gateway"
  namespace         = module.namespace.name
  name              = "seahax"
  loadbalancer_name = "seahax-k8s-gateway"
  hostnames         = ["api.seahax.com", "auth.seahax.com"]
}
