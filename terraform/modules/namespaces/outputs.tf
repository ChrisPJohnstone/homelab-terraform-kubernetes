output "network_namespace" {
  description = "Namespace for network assets"
  value       = kubernetes_namespace_v1.network_namespace.metadata[0].name
}

output "service_namespace" {
  description = "Namespace for service assets"
  value       = kubernetes_namespace_v1.service_namespace.metadata[0].name
}

output "longhorn_namespace" {
  description = "Namespace for longhorn assets"
  value       = kubernetes_namespace_v1.longhorn_namespace.metadata[0].name
}
