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

resource "cloudflare_dns_record" "tunnel" {
  for_each = var.hostnames
  zone_id  = var.zone_id
  name     = each.value
  type     = "CNAME"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  ttl      = 1
  proxied  = true
}

resource "kubernetes_secret_v1" "cloudflared" {
  metadata {
    namespace = var.namespace
    name      = "cloudflared"
  }
  data = {
    tunnel_token = data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel.token
  }
}

resource "kubernetes_deployment_v1" "cloudflared" {
  metadata {
    namespace = var.namespace
    name      = "cloudflared"
    labels = {
      app = "cloudflared"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "cloudflared"
      }
    }
    template {
      metadata {
        labels = {
          app = "cloudflared"
        }
      }
      spec {
        container {
          name  = "cloudflared"
          image = "docker.io/cloudflare/cloudflared:${var.cloudflared_version}"
          args  = ["tunnel", "--no-autoupdate", "--metrics", "0.0.0.0:2000", "run"]
          env {
            name = "TUNNEL_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.cloudflared.metadata[0].name
                key  = "tunnel_token"
              }
            }
          }
        }
      }
    }
  }
}
