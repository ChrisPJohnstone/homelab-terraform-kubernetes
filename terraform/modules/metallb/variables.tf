variable "namespace" {
  description = "Namespace to create resources under"
  type        = string
  nullable    = false
}

variable "metallb_version" {
  description = "Version of MetalLB to install"
  type        = string
  nullable    = false
  default     = "0.16.1"
}

variable "ip_pool_api_version" {
  description = "API Version for IP pool"
  type        = string
  nullable    = false
  default     = "metallb.io/v1beta1"
}

variable "ip_range" {
  description = "CIDR or range for IPAddressPool"
  type        = string
  nullable    = false
  default     = "192.168.122.200-192.168.122.250"
}

variable "l2_advertisement_api_version" {
  description = "API Version for L2 Advertisement"
  type        = string
  nullable    = false
  default     = "metallb.io/v1beta1"
}
