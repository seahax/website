module "seahax" {
  source            = "../../../modules/k8s_gateway"
  namespace         = "default"
  name              = "seahax"
  loadbalancer_name = "seahax-k8s-gateway"
  email             = "admin@seahax.com"

  listeners = {
    "api" = {
      hostname = "api.seahax.com"
    },
    "auth" = {
      hostname = "auth.seahax.com"
    },
  }
}
