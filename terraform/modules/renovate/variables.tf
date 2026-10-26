variable "namespace" {
  description = "Namespace to create resources under"
  type        = string
  nullable    = false
}

variable "renovate_token" {
  description = "GitHub token for renovate jobs"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "renovate_version" {
  description = "Version of Mend Renovate to install"
  type        = string
  nullable    = false
}
