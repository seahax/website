module "service" {
  source                   = "../../modules/k8s_service"
  namespace                = kubernetes_namespace_v1.self.metadata[0].name
  name                     = "service"
  image                    = "ghcr.io/seahax/api:${var.seahax_api_version}"
  container_port           = 8080
  gateway                  = module.gateway.name
  listeners                = values(module.gateway.https_listeners)
  prefix                   = "/"
  secret_env_yaml_file     = "${path.module}/.secret-env.yaml"
  secret_regcred_json_file = "${path.module}/.secret-regcred.json"
  restart_on_apply         = true

  env = {
    APP_ENVIRONMENT = "production",
  }
}
