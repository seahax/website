module "service-api" {
  source            = "../../modules/k8s_service"
  namespace         = "default"
  name              = "api"
  image             = "ghcr.io/seahax/api:latest"
  image_pull_secret = "regcred"
  replicas          = 1
  port              = 8080
  path              = "/"
  env = {
    APP_ENVIRONMENT = "production",
  }
  env_from_secret = [
    "mongodb.env",
    "smtp.env",
    "sentry.env"
  ]
}
