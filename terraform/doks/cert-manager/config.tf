terraform {
  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
    secret_suffix  = "cert-manager-state"
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
  }
}
