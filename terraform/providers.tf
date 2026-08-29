terraform {
  required_version = ">= 1.15.6, < 2.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}
