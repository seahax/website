module "service" {
  source            = "../../modules/k8s_service"
  namespace         = "default"
  name              = "api"
  image             = "ghcr.io/seahax/api:latest"
  image_pull_secret = "regcred"
  replicas          = 1
  ports             = [{ port = 8080 }]
  env = {
    APP_ENVIRONMENT = "production",
  }
  env_from_secret = [
    "mongodb.env",
    "smtp.env",
    "sentry.env"
  ]
}

module "route_root" {
  source       = "../../modules/k8s_http_route"
  namespace    = "default"
  name         = "api-root"
  listener     = "api"
  path         = "/"
  service_name = module.service.name
  service_port = module.service.ports[0]
}
