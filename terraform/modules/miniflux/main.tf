resource "random_password" "db_user_password" {
  keepers = {
    version = var.password_version
  }
  length      = 16
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

resource "postgresql_role" "miniflux" {
  depends_on          = [random_password.db_user_password]
  login               = true
  name                = "miniflux"
  password_wo         = local.db_password
  password_wo_version = var.password_version # Needs to be changed for password to be updated
}

resource "postgresql_database" "miniflux" {
  depends_on = [postgresql_role.miniflux]
  name       = "miniflux"
  owner      = postgresql_role.miniflux.id
}

resource "kubernetes_secret_v1" "miniflux" {
  depends_on = [postgresql_database.miniflux]
  metadata {
    namespace = var.namespace
    name      = "miniflux"
  }
  data = {
    db_password    = local.db_password
    database_url   = "postgres://miniflux:${urlencode(local.db_password)}@${var.db_host}/miniflux?sslmode=${var.db_ssl}"
    admin_password = var.admin_password
  }
}

resource "kubernetes_deployment_v1" "miniflux" {
  depends_on = [kubernetes_secret_v1.miniflux]
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
          image = "docker.io/miniflux/miniflux:${var.miniflux_version}"
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

resource "kubernetes_service_v1" "miniflux" {
  depends_on = [kubernetes_deployment_v1.miniflux]
  metadata {
    namespace = var.namespace
    name      = "miniflux"
    labels = {
      app = "miniflux"
    }
  }
  spec {
    selector = {
      app = "miniflux"
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}

resource "kubernetes_manifest" "miniflux_httproute" {
  depends_on = [kubernetes_service_v1.miniflux]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "miniflux"
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
          name = kubernetes_service_v1.miniflux.metadata[0].name
          port = 80
        }]
      }]
    }
  }
}
