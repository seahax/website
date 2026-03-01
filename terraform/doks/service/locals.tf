locals {
  images = yamldecode(file("${path.module}/config/images.yaml"))
}
