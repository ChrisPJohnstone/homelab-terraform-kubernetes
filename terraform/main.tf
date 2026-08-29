resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.metallb_namespace }
}

# TODO: Read through YAML and probably reorganise
resource "kubernetes_manifest" "metallb" {
  depends_on = [kubernetes_namespace_v1.namespace]
  for_each   = { for idx, doc in local.metallb_yaml : idx => doc }
  manifest   = yamldecode(each.value)
}
