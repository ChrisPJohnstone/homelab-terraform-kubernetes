output "gateway_name" {
  value = kubernetes_manifest.envoy_gateway.manifest.metadata.name
}
