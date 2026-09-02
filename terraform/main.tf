resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "metallb" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/metallb/"
  namespace  = local.namespace
}

module "envoy" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/envoy/"
  namespace  = local.namespace
}

module "miniflux" {
  depends_on     = [kubernetes_namespace_v1.namespace]
  source         = "./modules/miniflux/"
  namespace      = local.namespace
  db_host        = var.miniflux_db_host
  db_password    = var.miniflux_db_password
  admin_username = var.miniflux_admin_username
  admin_password = var.miniflux_admin_password
  gateway_name   = module.envoy.gateway_name
}
