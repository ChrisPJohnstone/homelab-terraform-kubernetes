resource "kubernetes_namespace_v1" "network_namespace" {
  metadata { name = var.network_namespace }
}

resource "kubernetes_namespace_v1" "service_namespace" {
  metadata { name = var.service_namespace }
}

resource "kubernetes_namespace_v1" "longhorn_namespace" {
  metadata { name = var.longhorn_namespace }
}

module "metallb" {
  depends_on      = [kubernetes_namespace_v1.network_namespace]
  source          = "./modules/metallb/"
  namespace       = local.network_namespace
  metallb_version = var.metallb_version
}

module "envoy" {
  depends_on            = [kubernetes_namespace_v1.network_namespace]
  source                = "./modules/envoy/"
  namespace             = local.network_namespace
  envoy_gateway_version = var.envoy_gateway_version
  gateway_ip            = var.gateway_ip
  gateway_port          = var.gateway_port
  service_namespace     = local.service_namespace
}

module "longhorn" {
  depends_on       = [kubernetes_namespace_v1.longhorn_namespace]
  source           = "./modules/longhorn/"
  namespace        = local.longhorn_namespace
  longhorn_version = var.longhorn_version
}

module "vaultwarden" {
  depends_on = [
    kubernetes_namespace_v1.service_namespace,
    module.envoy,
    module.longhorn,
  ]
  source              = "./modules/vaultwarden"
  namespace           = local.service_namespace
  gateway_name        = module.envoy.gateway_name
  gateway_namespace   = module.envoy.gateway_namespace
  domain              = var.domain
  subdomain           = "wip" # TODO: Migrate & Remove
  vaultwarden_version = var.vaultwarden_version
}

module "miniflux" {
  depends_on = [
    kubernetes_namespace_v1.service_namespace,
    module.envoy,
  ]
  source            = "./modules/miniflux/"
  namespace         = local.service_namespace
  gateway_name      = module.envoy.gateway_name
  gateway_namespace = module.envoy.gateway_namespace
  domain            = var.domain
  miniflux_version  = var.miniflux_version
  db_host           = var.postgres_host
  admin_username    = var.miniflux_admin_username
}

module "cloudflare" {
  depends_on = [
    kubernetes_namespace_v1.network_namespace,
    module.miniflux,
    module.vaultwarden,
  ]
  source              = "./modules/cloudflare/"
  account_id          = var.cloudflare_account_id
  zone_id             = var.cloudflare_zone_id
  gateway_ip          = var.gateway_ip
  gateway_port        = var.gateway_port
  namespace           = local.network_namespace
  cloudflared_version = var.cloudflared_version
  hostnames = [
    module.miniflux.hostname,
    module.vaultwarden.hostname,
  ]
}
