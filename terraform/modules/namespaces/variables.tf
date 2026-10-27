variable "network_namespace" {
  description = "Namespaces to create for networking"
  type        = string
  nullable    = false
}

variable "longhorn_namespace" {
  description = "Namespace to create for Longhorn"
  type        = string
  nullable    = false
}

variable "service_namespace" {
  description = "Namespaces to create for services"
  type        = string
  nullable    = false
}
