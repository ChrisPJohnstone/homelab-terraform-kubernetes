module "namespaces" {
  source             = "./modules/namespaces"
  network_namespace  = var.network_namespace
  service_namespace  = var.service_namespace
  longhorn_namespace = var.longhorn_namespace
}

module "metallb" {
  depends_on      = [module.namespaces]
  source          = "./modules/metallb/"
  namespace       = module.namespaces.network_namespace
  metallb_version = var.metallb_version
}

module "envoy" {
  depends_on            = [module.namespaces]
  source                = "./modules/envoy/"
  namespace             = module.namespaces.network_namespace
  envoy_gateway_version = var.envoy_gateway_version
  gateway_ip            = var.gateway_ip
  gateway_port          = var.gateway_port
  service_namespace     = module.namespaces.service_namespace
}

module "longhorn" {
  depends_on       = [module.namespaces]
  source           = "./modules/longhorn/"
  namespace        = module.namespaces.longhorn_namespace
  longhorn_version = var.longhorn_version
}

module "renovate" {
  depends_on       = [module.namespaces]
  source           = "./modules/renovate/"
  namespace        = module.namespaces.service_namespace
  renovate_token   = var.renovate_token
  renovate_version = var.renovate_version
}

module "vaultwarden" {
  depends_on = [
    module.namespaces,
    module.envoy,
    module.longhorn,
  ]
  source              = "./modules/vaultwarden"
  namespace           = module.namespaces.service_namespace
  gateway_name        = module.envoy.gateway_name
  gateway_namespace   = module.envoy.gateway_namespace
  domain              = var.domain
  vaultwarden_version = var.vaultwarden_version
  db_host             = var.postgres_host
  smtp_host           = var.smtp_host
  smtp_port           = var.smtp_port
  smtp_security       = var.smtp_security
  smtp_username       = var.smtp_username
  smtp_password       = var.smtp_password
  smtp_from_email     = var.smtp_from_email
  enable_admin_panel  = var.vaultwarden_enable_admin_panel
}

module "miniflux" {
  depends_on = [
    module.namespaces,
    module.envoy,
  ]
  source            = "./modules/miniflux/"
  namespace         = module.namespaces.service_namespace
  gateway_name      = module.envoy.gateway_name
  gateway_namespace = module.envoy.gateway_namespace
  domain            = var.domain
  miniflux_version  = var.miniflux_version
  db_host           = var.postgres_host
  admin_username    = var.miniflux_admin_username
}

module "joplin" {
  depends_on = [
    module.namespaces,
    module.envoy,
  ]
  source             = "./modules/joplin/"
  namespace          = module.namespaces.service_namespace
  gateway_name       = module.envoy.gateway_name
  gateway_namespace  = module.envoy.gateway_namespace
  domain             = var.domain
  joplin_version     = var.joplin_version
  db_host            = var.postgres_host
  smtp_host          = var.smtp_host
  smtp_port          = var.smtp_port
  smtp_security      = var.smtp_security
  smtp_username      = var.smtp_username
  smtp_password      = var.smtp_password
  smtp_from_email    = var.smtp_from_email
  enable_admin_panel = var.joplin_enable_admin_panel
}

module "cloudflare" {
  depends_on = [
    module.joplin,
    module.miniflux,
    module.namespaces,
    module.vaultwarden,
  ]
  source              = "./modules/cloudflare/"
  account_id          = var.cloudflare_account_id
  zone_id             = var.cloudflare_zone_id
  gateway_ip          = var.gateway_ip
  gateway_port        = var.gateway_port
  namespace           = module.namespaces.network_namespace
  cloudflared_version = var.cloudflared_version
  hostnames = [
    module.joplin.hostname,
    module.miniflux.hostname,
    module.vaultwarden.hostname,
  ]
}
