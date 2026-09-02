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

resource "kubernetes_service_v1" "miniflux" {
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
      hostnames = [var.hostname]
      rules = [{
        backendRefs = [{
          name = kubernetes_service_v1.miniflux.metadata[0].name
          port = 80
        }]
      }]
    }
  }
}
