locals {
  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  metallb_yaml = split("\n---\n", templatefile("../manifests/metallb.yaml", {
    namespace = var.metallb_namespace
  }))
}
