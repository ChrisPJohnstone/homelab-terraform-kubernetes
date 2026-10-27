resource "kubernetes_namespace_v1" "network_namespace" {
  metadata { name = var.network_namespace }
}

resource "kubernetes_namespace_v1" "service_namespace" {
  metadata { name = var.service_namespace }
}

resource "kubernetes_namespace_v1" "longhorn_namespace" {
  metadata { name = var.longhorn_namespace }
}

