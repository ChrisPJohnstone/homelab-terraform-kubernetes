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
            name  = "DATABASE_URL"
            value = "postgres://miniflux:${var.db_password}@${var.db_host}/miniflux?sslmode=${var.db_ssl}"
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
          # TODO: Password exposed
          env {
            name  = "ADMIN_PASSWORD"
            value = var.admin_password
          }
        }
      }
    }
  }
}
