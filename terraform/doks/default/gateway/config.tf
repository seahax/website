terraform {
  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
    secret_suffix  = "default-gateway-state"
    namespace      = "terraform"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "do-sfo3-seahax"
}
