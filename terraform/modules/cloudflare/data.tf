data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel" {
  depends_on = [cloudflare_zero_trust_tunnel_cloudflared.tunnel]
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}
