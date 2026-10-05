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

variable "kubeconfig_path" {
  description = "Where to store kubeconfig"
  type        = string
  nullable    = false
  default     = "../.kubeconfig"
}

variable "postgres_host" {
  description = "Path to postgres host"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "postgres_port" {
  description = "Port to connecto to postgres on"
  type        = number
  nullable    = false
  sensitive   = true
  default     = 5432
}

variable "postgres_username" {
  description = "Username to connect to postgres"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "postgres_password" {
  description = "Password to connect to postgres"
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

variable "network_namespace" {
  description = "Namespaces to create for networking pods"
  type        = string
  nullable    = false
  default     = "networking"
}

variable "service_namespace" {
  description = "Namespaces to create for services"
  type        = string
  nullable    = false
  default     = "services"
}

variable "metallb_version" {
  description = "Version of metallb to install"
  type        = string
  nullable    = false
}

variable "envoy_gateway_version" {
  description = "Version of envoy gateway to install"
  type        = string
  nullable    = false
}

variable "cloudflared_version" {
  description = "Version of cloudflared to install"
  type        = string
  nullable    = false
}

variable "miniflux_version" {
  description = "Version of miniflux to install"
  type        = string
  nullable    = false
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
