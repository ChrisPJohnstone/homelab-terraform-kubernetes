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
}

variable "miniflux_db_ssl" {
  description = "Wether to use to use SSL for miniflux database connection"
  type        = string
  nullable    = false
  default     = "disable"
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
}
