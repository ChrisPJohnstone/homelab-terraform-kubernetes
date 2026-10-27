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

resource "postgresql_role" "joplin" {
  depends_on          = [random_password.db_password]
  login               = true
  name                = var.db_username
  password_wo         = local.db_password
  password_wo_version = var.db_password_version # Needs to be changed for password to be updated
}

# Lifecycle disables deletion by default to prevent loss of data
# If you are looking to delete just remove/toggle the lifecycle rule
#
# There are scripts in the `scripts/` dir to assist with backing up
# and restoring database using `pg_dump` & `psql`
resource "postgresql_database" "joplin" {
  depends_on = [postgresql_role.joplin]
  name       = var.db_name
  owner      = postgresql_role.joplin.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_secret_v1" "joplin" {
  depends_on = [postgresql_database.joplin]
  metadata {
    namespace = var.namespace
    name      = "joplin"
  }
  data = {
    APP_BASE_URL               = "https://${local.hostname}"
    DB_CLIENT                  = "pg"
    POSTGRES_CONNECTION_STRING = "postgres://${var.db_username}:${urlencode(local.db_password)}@${var.db_host}/${var.db_name}?sslmode=${var.db_ssl}"
    IS_ADMIN_INSTANCE          = var.enable_admin_panel
    DEFAULT_ADMIN_PASSWORD     = local.admin_token
    MAILER_ENABLED             = true,
    MAILER_HOST                = var.smtp_host
    MAILER_PORT                = var.smtp_port
    MAILER_SECURITY            = var.smtp_security
    MAILER_AUTH_USER           = var.smtp_username
    MAILER_AUTH_PASSWORD       = var.smtp_password
    MAILER_NOREPLY_NAME        = var.smtp_from_name
    MAILER_NOREPLY_EMAIL       = var.smtp_from_email
  }
}

resource "kubernetes_deployment_v1" "joplin" {
  depends_on = [kubernetes_secret_v1.joplin]
  metadata {
    namespace = var.namespace
    name      = "joplin"
    labels = {
      app = "joplin"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "joplin"
      }
    }
    template {
      metadata {
        labels = {
          app = "joplin"
        }
      }
      spec {
        container {
          name  = "joplin"
          image = "docker.io/joplin/server:${var.joplin_version}"
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.joplin.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "joplin" {
  depends_on = [kubernetes_deployment_v1.joplin]
  metadata {
    namespace = var.namespace
    name      = "joplin"
    labels = {
      app = "joplin"
    }
  }
  spec {
    selector = {
      app = "joplin"
    }
    port {
      port        = 80
      target_port = 22300
    }
  }
}

resource "kubernetes_manifest" "joplin_httproute" {
  depends_on = [kubernetes_service_v1.joplin]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "joplin"
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
          name = kubernetes_service_v1.joplin.metadata[0].name
          port = 80
        }]
      }]
    }
  }
}
