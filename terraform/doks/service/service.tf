module "service" {
  source                   = "../../modules/k8s_service"
  namespace                = module.namespace.name
  name                     = "service"
  image                    = "${local.images.api.name}:${local.images.api.version}"
  gateway                  = module.gateway.name
  listeners                = [module.gateway.listeners["api.seahax.com"]]
  secret_env_yaml_file     = "${path.module}/config/.secret-env.yaml"
  secret_regcred_json_file = "${path.module}/config/.secret-regcred.json"

  env = {
    APP_ENVIRONMENT = "production",
    APP_LOG_LEVEL   = "debug"
  }
}
