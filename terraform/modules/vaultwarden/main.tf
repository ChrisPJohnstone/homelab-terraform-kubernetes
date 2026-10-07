# TODO: Create user and disable signups
# TODO: Move to Postgres database

resource "random_password" "db_password" {
  keepers = {
    version = var.db_password_version
  }
  length      = 16
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

resource "random_password" "admin_token" {
  keepers = {
    version = var.admin_token_version
  }
  length      = 16
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

resource "postgresql_role" "vaultwarden" {
  depends_on          = [random_password.db_password]
  login               = true
  name                = var.db_username
  password_wo         = local.db_password
  password_wo_version = var.db_password_version # Needs to be changed for password to be updated
}

resource "postgresql_database" "vaultwarden" {
  depends_on = [postgresql_role.vaultwarden]
  name       = var.db_name
  owner      = postgresql_role.vaultwarden.id
}

resource "kubernetes_secret_v1" "vaultwarden" {
  depends_on = [postgresql_database.vaultwarden]
  metadata {
    namespace = var.namespace
    name      = "vaultwarden"
  }
  data = {
    database_url = "postgres://${var.db_username}:${urlencode(local.db_password)}@${var.db_host}/${var.db_name}?sslmode=${var.db_ssl}"
    admin_token  = local.admin_token
  }
}

resource "kubernetes_persistent_volume_claim_v1" "vaultwarden_data" {
  metadata {
    namespace = var.namespace
    name      = "vaultwarden-data"
    labels = {
      app = "vaultwarden"
    }
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

resource "kubernetes_deployment_v1" "vaultwarden" {
  depends_on = [
    kubernetes_persistent_volume_claim_v1.vaultwarden_data,
    kubernetes_secret_v1.vaultwarden,
  ]
  metadata {
    namespace = var.namespace
    name      = "vaultwarden"
    labels = {
      app = "vaultwarden"
    }
  }
  spec {
    replicas = 1 # TODO: Implement HA
    selector {
      match_labels = {
        app = "vaultwarden"
      }
    }
    template {
      metadata {
        labels = {
          app = "vaultwarden"
        }
      }
      spec {
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.vaultwarden_data.metadata[0].name
          }
        }
        container {
          name  = "vaultwarden"
          image = "docker.io/vaultwarden/server:${var.vaultwarden_version}"
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }
          env {
            name  = "DOMAIN"
            value = "https://${local.hostname}"
          }
          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.vaultwarden.metadata[0].name
                key  = "database_url"
              }
            }
          }
          dynamic "env" {
            for_each = var.enable_admin_panel ? [1] : []
            content {
              name = "ADMIN_TOKEN"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret_v1.vaultwarden.metadata[0].name
                  key  = "admin_token"
                }
              }
            }
          }
          env {
            name  = "SIGNUPS_ALLOWED"
            value = false
          }
          env {
            name  = "SMTP_HOST"
            value = var.smtp_host
          }
          env {
            name  = "SMTP_PORT"
            value = var.smtp_port
          }
          env {
            name  = "SMTP_SECURITY"
            value = var.smtp_security
          }
          env {
            name  = "SMTP_USERNAME"
            value = var.smtp_username
          }
          env {
            name  = "SMTP_PASSWORD"
            value = var.smtp_password
          }
          env {
            name  = "SMTP_FROM"
            value = var.smtp_from_email
          }
          env {
            name  = "SMTP_FROM_NAME"
            value = var.smtp_from_name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "vaultwarden" {
  depends_on = [kubernetes_deployment_v1.vaultwarden]
  metadata {
    namespace = var.namespace
    name      = "vaultwarden"
    labels = {
      app = "vaultwarden"
    }
  }
  spec {
    selector = {
      app = "vaultwarden"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_manifest" "miniflux_httproute" {
  depends_on = [kubernetes_service_v1.vaultwarden]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "vaultwarden"
      namespace = var.namespace
    }
    spec = {
      parentRefs = [{
        name      = var.gateway_name
        namespace = var.gateway_namespace
      }]
      hostnames = [local.hostname]
      rules = [{
        backendRefs = [{
          name = kubernetes_service_v1.vaultwarden.metadata[0].name
          port = 80
        }]
      }]
    }
  }
}
