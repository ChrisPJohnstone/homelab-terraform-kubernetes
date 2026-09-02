resource "kubernetes_secret_v1" "miniflux" {
  metadata {
    namespace = var.namespace
    name      = "miniflux"
  }
  data = {
    db_password    = var.db_password
    database_url   = "postgres://miniflux:${var.db_password}@${var.db_host}/miniflux?sslmode=${var.db_ssl}"
    admin_password = var.admin_password
  }
}

# TODO: Set up service
resource "kubernetes_deployment_v1" "miniflux" {
  metadata {
    namespace = var.namespace
    name      = "miniflux"
    labels = {
      app = "miniflux"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "miniflux"
      }
    }
    template {
      metadata {
        labels = {
          app = "miniflux"
        }
      }
      spec {
        container {
          name  = "miniflux"
          image = "docker.io/miniflux/miniflux:latest"
          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.miniflux.metadata[0].name
                key  = "database_url"
              }
            }
          }
          env {
            name  = "RUN_MIGRATIONS"
            value = "1"
          }
          env {
            name  = "CREATE_ADMIN"
            value = "1"
          }
          env {
            name  = "ADMIN_USERNAME"
            value = var.admin_username
          }
          env {
            name = "ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.miniflux.metadata[0].name
                key  = "admin_password"
              }
            }
          }
        }
      }
    }
  }
}
