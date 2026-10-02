resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.account_id
  name       = var.tunnel_name
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel" {
  depends_on = [cloudflare_zero_trust_tunnel_cloudflared.tunnel]
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  source     = "cloudflare"
  config = {
    ingress = concat(
      [for hostname in var.hostnames : {
        hostname = hostname
        service  = "http://${var.gateway_ip}:${var.gateway_port}"
      }],
      [{
        hostname = null
        service  = "http_status:404"
      }]
    )
  }
}

# TODO: Create DNS record
# TODO: Deploy cloudfared to cluster
