module "service" {
  source                   = "../../modules/k8s_service"
  namespace                = module.namespace.name
  name                     = "service"
  image                    = "ghcr.io/seahax/api:${var.seahax_api_version}"
  gateway                  = module.gateway.name
  listeners                = [module.gateway.https_listeners["api.seahax.com"]]
  secret_env_yaml_file     = "${path.module}/.secret-env.yaml"
  secret_regcred_json_file = "${path.module}/.secret-regcred.json"

  env = {
    APP_ENVIRONMENT = "production",
  }
}
