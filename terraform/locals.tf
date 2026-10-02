locals {
  network_namespace = kubernetes_namespace_v1.network_namespace.metadata[0].name
  service_namespace = kubernetes_namespace_v1.service_namespace.metadata[0].name
}
