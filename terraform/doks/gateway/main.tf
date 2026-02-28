module "self" {
  source    = "../../modules/k8s_gateway"
  namespace = "default"
  name      = "gateway"
  email     = "admin@seahax.com"

  listeners = {
    "api" = {
      hostname = "api.seahax.com"
    },
    "auth" = {
      hostname = "auth.seahax.com"
    },
  }
}
