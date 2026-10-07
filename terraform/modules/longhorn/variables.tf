variable "namespace" {
  description = "Namespace to create resources under"
  type        = string
  nullable    = false
}

variable "longhorn_version" {
  description = "Version of Longhorn to install"
  type        = string
  nullable    = false
}

variable "replica_count" {
  description = "Number of replicas per Longhorn volume"
  type        = number
  nullable    = false
  default     = 2
}
