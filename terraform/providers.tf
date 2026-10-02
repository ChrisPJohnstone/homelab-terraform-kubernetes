terraform {
  required_version = ">= 1.15.6, < 2.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.26"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_path
  }
}
