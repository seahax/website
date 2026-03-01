resource "kubernetes_secret_v1" "env" {
  count = var.secret_env_yaml_file == null ? 0 : 1

  metadata {
    namespace = var.namespace
    name      = "${var.name}-env"
  }

  type = "Opaque"
  data = yamldecode(file(var.secret_env_yaml_file))
}

resource "kubernetes_secret_v1" "regcred" {
  count = var.secret_regcred_json_file == null ? 0 : 1

  metadata {
    namespace = var.namespace
    name      = "${var.name}-regcred"
  }

  type = "kubernetes.io/dockerconfigjson"
  data = { ".dockerconfigjson" = file(var.secret_regcred_json_file) }
}
