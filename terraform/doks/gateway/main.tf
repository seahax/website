module "self" {
  source    = "../_modules/gateway"
  namespace = "default"
  name      = "gateway"
  hostname  = "api.seahax.com"
  email     = "admin@seahax.com"
}
