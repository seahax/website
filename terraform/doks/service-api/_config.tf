terraform {
  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
    secret_suffix  = "service-api-state"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "do-sfo3-seahax"
}
