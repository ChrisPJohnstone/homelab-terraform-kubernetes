output "gateway_namespace" {
  description = "Namespace the gateway is created in"
  value       = kubernetes_manifest.envoy_gateway.manifest.metadata.namespace
}

output "gateway_name" {
  description = "Name of the envoy gateway manifest"
  value       = kubernetes_manifest.envoy_gateway.manifest.metadata.name
}
