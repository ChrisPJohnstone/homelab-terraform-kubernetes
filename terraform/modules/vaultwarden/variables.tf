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
  default     = "vaultwarden"
}

variable "vaultwarden_version" {
  description = "Version of vaultwarden to install"
  type        = string
  nullable    = false
}
