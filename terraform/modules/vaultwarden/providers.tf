terraform {
  required_version = ">= 1.15.6, < 2.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.27"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
  }
}
