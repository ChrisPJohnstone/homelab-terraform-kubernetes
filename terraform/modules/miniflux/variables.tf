variable "namespace" {
  description = "Name to create namespace under"
  type        = string
  nullable    = false
  default     = "homelab"
}

variable "db_host" {
  description = "Host address for miniflux database"
  type        = string
  nullable    = false
}

variable "db_password" {
  description = "Password for miniflux database user"
  type        = string
  nullable    = false
  sensitive   = true
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

variable "gateway_name" {
  description = "Name of the Gateway to attach the miniflux HTTPRoute to"
  type        = string
  nullable    = false
  default     = "envoy-gateway"
}

variable "gateway_namespace" {
  description = "Namespace of the Gateway to attach the miniflux HTTPRoute to"
  type        = string
  nullable    = false
  default     = "homelab"
}

variable "hostname" {
  description = "Hostname to route to the miniflux service"
  type        = string
  nullable    = false
  default     = "miniflux.home.lab"
}
