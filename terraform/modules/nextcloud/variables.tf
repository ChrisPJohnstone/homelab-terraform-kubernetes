variable "namespace" {
  description = "Namespace to deploy service in"
  type        = string
  nullable    = false
}

variable "gateway_name" {
  description = "Name of the Gateway to attach the HTTPRoute to"
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
  description = "Domain name to route to the service"
  type        = string
  nullable    = false
}

variable "subdomain" {
  description = "Subdomain to route to the service"
  type        = string
  nullable    = false
  default     = "nextcloud"
}

variable "nextcloud_version" {
  description = "Version of nextcloud to install"
  type        = string
  nullable    = false
}

variable "db_host" {
  description = "Host address for the database"
  type        = string
  nullable    = false
}

variable "db_username" {
  description = "Username to use for database connection"
  type        = string
  nullable    = false
  default     = "nextcloud"
}

variable "db_password_version" {
  description = "Password resources can't track state properly while protecting password, to update password change this string"
  type        = string
  nullable    = false
  default     = "one"
}

variable "db_name" {
  description = "Name to create database as"
  type        = string
  nullable    = false
  default     = "nextcloud"
}

variable "admin_username" {
  description = "Username to give admin user"
  type        = string
  nullable    = false
}

variable "admin_password_version" {
  description = "Password resources can't track state properly while protecting password, to update password change this string"
  type        = string
  nullable    = false
  default     = "one"
}

variable "smtp_host" {
  description = "Host to connect to SMTP server"
  type        = string
  nullable    = false
}

variable "smtp_port" {
  description = "Port to connect to SMTP server on"
  type        = number
  nullable    = false
}

variable "smtp_security" {
  description = "Security protocol for SMTP server"
  type        = string
  nullable    = false
}

variable "smtp_username" {
  description = "Username to log in to SMTP server"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "smtp_password" {
  description = "Password to log in to SMTP server"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "smtp_from_email" {
  description = "Email address to show emails from"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "smtp_from_name" {
  description = "Name to show emails from"
  type        = string
  nullable    = false
  default     = "vaultwarden"
}

variable "storage_class_name" {
  description = "StorageClass for Vaultwarden PVC"
  type        = string
  nullable    = false
  default     = "longhorn"
}

variable "storage_size" {
  description = "PVC size for Vaultwarden data"
  type        = string
  nullable    = false
  default     = "5Gi"
}
