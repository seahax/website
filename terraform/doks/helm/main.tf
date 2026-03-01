terraform {
  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
    namespace      = "terraform"
    secret_suffix  = "helm"
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "do-sfo3-seahax"
  }
}
