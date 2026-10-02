resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "metallb" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/metallb/"
  namespace  = local.namespace
}

module "envoy" {
  depends_on   = [kubernetes_namespace_v1.namespace]
  source       = "./modules/envoy/"
  namespace    = local.namespace
  gateway_ip   = var.gateway_ip
  gateway_port = var.gateway_port
}

module "miniflux" {
  depends_on = [
    kubernetes_namespace_v1.namespace,
    module.envoy,
  ]
  source         = "./modules/miniflux/"
  namespace      = local.namespace
  db_host        = var.miniflux_db_host
  db_password    = var.miniflux_db_password
  admin_username = var.miniflux_admin_username
  admin_password = var.miniflux_admin_password
  gateway_name   = module.envoy.gateway_name
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.cloudflare_account_id
  name       = "kubernetes"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel" {
  depends_on = [cloudflare_zero_trust_tunnel_cloudflared.tunnel]
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  source     = "cloudflare"
  config = {
    ingress = [{
      hostname = "miniflux.${var.domain}"
      service  = "http://${var.gateway_ip}:${var.gateway_port}"
      }, {
      hostname = null
      service  = "http_status:404"
    }]
  }
}

# TODO: Deploy cloudfared to cluster
# TODO: Move cloudflare tunnel to module
