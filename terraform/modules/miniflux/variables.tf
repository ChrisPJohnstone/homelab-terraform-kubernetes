variable "namespace" {
  description = "Namespace to deploy service in"
  type        = string
  nullable    = false
}

variable "db_host" {
  description = "Host address for miniflux database"
  type        = string
  nullable    = false
}

variable "db_ssl" {
  description = "Wether to use to use SSL for miniflux database connection"
  type        = string
  nullable    = false
  default     = "disable"
}

variable "admin_username" {
  description = "Username to give miniflux admin user"
  type        = string
  nullable    = false
}

variable "admin_password" {
  description = "Password to give miniflux admin user"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "miniflux_version" {
  description = "Version of miniflux to install"
  type        = string
  nullable    = false
}

variable "gateway_name" {
  description = "Name of the Gateway to attach the miniflux HTTPRoute to"
  type        = string
  nullable    = false
  default     = "envoy-gateway"
}

variable "gateway_namespace" {
  description = "Namespace that the Gateway is deployed in"
  type        = string
  nullable    = false
}

variable "domain" {
  description = "Domain name to route to the miniflux service"
  type        = string
  nullable    = false
}

variable "subdomain" {
  description = "Subdomain to route to the miniflux service"
  type        = string
  nullable    = false
  default     = "miniflux"
}

variable "password_version" {
  description = "Password resources can't track state properly while protecting password, to update password change this string"
  type        = string
  nullable    = false
  default     = "one"
}
