resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "metallb" {
  depends_on      = [kubernetes_namespace_v1.namespace]
  source          = "./modules/metallb/"
  namespace       = local.namespace
  metallb_version = "0.16.1"
}

module "envoy" {
  depends_on            = [kubernetes_namespace_v1.namespace]
  source                = "./modules/envoy/"
  namespace             = local.namespace
  envoy_gateway_version = "1.8.1"
  gateway_ip            = var.gateway_ip
  gateway_port          = var.gateway_port
}

module "miniflux" {
  depends_on = [
    kubernetes_namespace_v1.namespace,
    module.envoy,
  ]
  source           = "./modules/miniflux/"
  namespace        = local.namespace
  miniflux_version = "2.3.3"
  db_host          = var.miniflux_db_host
  db_password      = var.miniflux_db_password
  admin_username   = var.miniflux_admin_username
  admin_password   = var.miniflux_admin_password
  gateway_name     = module.envoy.gateway_name
  domain           = var.domain
}

module "cloudflare" {
  depends_on = [
    kubernetes_namespace_v1.namespace,
    module.miniflux,
  ]
  source              = "./modules/cloudflare/"
  account_id          = var.cloudflare_account_id
  zone_id             = var.cloudflare_zone_id
  gateway_ip          = var.gateway_ip
  gateway_port        = var.gateway_port
  hostnames           = [module.miniflux.hostname]
  namespace           = local.namespace
  cloudflared_version = "2026.9.3"
}
