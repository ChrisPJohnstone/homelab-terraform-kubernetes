resource "kubernetes_namespace_v1" "network_namespace" {
  metadata { name = var.network_namespace }
}

resource "kubernetes_namespace_v1" "service_namespace" {
  metadata { name = var.service_namespace }
}

module "metallb" {
  depends_on      = [kubernetes_namespace_v1.network_namespace]
  source          = "./modules/metallb/"
  namespace       = local.network_namespace
  metallb_version = "0.16.1"
}

module "envoy" {
  depends_on            = [kubernetes_namespace_v1.network_namespace]
  source                = "./modules/envoy/"
  namespace             = local.network_namespace
  envoy_gateway_version = "1.8.1"
  gateway_ip            = var.gateway_ip
  gateway_port          = var.gateway_port
  service_namespace     = local.service_namespace
}

module "miniflux" {
  depends_on = [
    kubernetes_namespace_v1.service_namespace,
    module.envoy,
  ]
  source            = "./modules/miniflux/"
  namespace         = local.service_namespace
  miniflux_version  = "2.3.3"
  db_host           = var.miniflux_db_host
  db_password       = var.miniflux_db_password
  admin_username    = var.miniflux_admin_username
  admin_password    = var.miniflux_admin_password
  gateway_name      = module.envoy.gateway_name
  gateway_namespace = module.envoy.gateway_namespace
  domain            = var.domain
}

module "cloudflare" {
  depends_on = [
    kubernetes_namespace_v1.network_namespace,
    module.miniflux,
  ]
  source              = "./modules/cloudflare/"
  account_id          = var.cloudflare_account_id
  zone_id             = var.cloudflare_zone_id
  gateway_ip          = var.gateway_ip
  gateway_port        = var.gateway_port
  hostnames           = [module.miniflux.hostname]
  namespace           = local.network_namespace
  cloudflared_version = "2026.9.3"
}
