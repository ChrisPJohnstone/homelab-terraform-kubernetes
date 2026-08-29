variable "kubeconfig_path" {
  description = "Where to store kubeconfig"
  type        = string
  nullable    = false
  default     = "../.kubeconfig"
}

variable "metallb_namespace" {
  description = "Where to store kubeconfig"
  type        = string
  nullable    = false
  default     = "metallb-system"
}
