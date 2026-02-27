module "self" {
  source    = "../../modules/k8s_gateway"
  namespace = "default"
  name      = "gateway"
  hostname  = "api.seahax.com"
  email     = "admin@seahax.com"
}
