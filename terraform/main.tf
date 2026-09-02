resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "metallb" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/metallb/"
  namespace  = local.namespace
}

module "envoy" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/envoy/"
  namespace  = local.namespace
}

# TODO: Set up service
resource "kubernetes_deployment_v1" "miniflux" {
  depends_on = [kubernetes_namespace_v1.namespace]
  metadata {
    namespace = local.namespace
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
            value = "postgres://miniflux:${var.miniflux_db_password}@${var.miniflux_db_host}/miniflux?sslmode=${var.miniflux_db_ssl}"
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
            value = var.miniflux_admin_username
          }
          # TODO: Password exposed
          env {
            name  = "ADMIN_PASSWORD"
            value = var.miniflux_admin_password
          }
        }
      }
    }
  }
}
