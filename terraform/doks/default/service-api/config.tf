terraform {
  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
    secret_suffix  = "default-service-api-state"
    namespace      = "terraform"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "do-sfo3-seahax"
}
