resource "helm_release" "metallb_release" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = var.metallb_version
  namespace        = var.namespace
  create_namespace = false
  wait             = true
}

resource "kubernetes_manifest" "ip_address_pool" {
  depends_on = [helm_release.metallb_release]
  manifest = {
    apiVersion = var.ip_pool_api_version
    kind       = "IPAddressPool"
    metadata = {
      name      = "default-pool"
      namespace = var.namespace
    }
    spec = {
      addresses = [var.ip_range]
    }
  }
}

resource "kubernetes_manifest" "l2_advertisement" {
  depends_on = [kubernetes_manifest.ip_address_pool]
  manifest = {
    apiVersion = var.l2_advertisement_api_version
    kind       = "L2Advertisement"
    metadata = {
      name      = "default-l2"
      namespace = var.namespace
    }
    spec = {
      ipAddressPools = [kubernetes_manifest.ip_address_pool.manifest.metadata.name]
    }
  }
}
