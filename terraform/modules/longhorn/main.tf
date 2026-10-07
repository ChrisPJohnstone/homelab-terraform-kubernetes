resource "helm_release" "longhorn_release" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  version          = var.longhorn_version
  namespace        = var.namespace
  create_namespace = false
  wait             = true
  set = [
    {
      name  = "persistence.defaultClass"
      value = "true"
    },
    {
      name  = "persistence.defaultClassReplicaCount"
      value = tostring(var.replica_count)
    },
  ]
}
