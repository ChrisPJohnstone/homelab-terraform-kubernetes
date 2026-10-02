output "gateway_name" {
  description = "Name of the envoy gateway manifest"
  value       = kubernetes_manifest.envoy_gateway.manifest.metadata.name
}
