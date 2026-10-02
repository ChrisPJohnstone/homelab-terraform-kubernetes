variable "cloudflare_api_token" {
  description = "API token for connecting to cloudflare"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "domain" {
  description = "Domain for cloudflare tunnel"
  type        = string
  nullable    = false
}

variable "gateway_ip" {
  description = "Static IP to assign to the Gateway"
  type        = string
  nullable    = false
  sensitive   = true
  default     = "192.168.0.220"
}

variable "gateway_port" {
  description = "Port for the gateway to listen on"
  type        = string
  nullable    = false
  default     = 80
}

variable "kubeconfig_path" {
  description = "Where to store kubeconfig"
  type        = string
  nullable    = false
  default     = "../.kubeconfig"
}

variable "namespace" {
  description = "Name to create namespace under"
  type        = string
  nullable    = false
  default     = "homelab"
}

variable "envoy_gateway_version" {
  description = "Version of envoy gateway to install"
  type        = string
  nullable    = false
  default     = "1.8.1"
}

variable "miniflux_db_host" {
  description = "Host address for miniflux database"
  type        = string
  nullable    = false
}

variable "miniflux_db_password" {
  description = "Password for miniflux database user"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "miniflux_admin_username" {
  description = "Username to give miniflux admin user"
  type        = string
  nullable    = false
}

variable "miniflux_admin_password" {
  description = "Password to give miniflux admin user"
  type        = string
  nullable    = false
  sensitive   = true
}
