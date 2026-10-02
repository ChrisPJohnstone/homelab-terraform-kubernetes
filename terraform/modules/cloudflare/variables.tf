variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "tunnel_name" {
  description = "Name to create tunnel under"
  type        = string
  nullable    = false
  default     = "kubernetes"
}

variable "gateway_ip" {
  description = "Static IP to assign to the Gateway"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "gateway_port" {
  description = "Port for the gateway to listen on"
  type        = string
  nullable    = false
}

variable "hostnames" {
  description = "Public hostnames to route to the Gateway over the tunnel"
  type        = set(string)
  nullable    = false
}
