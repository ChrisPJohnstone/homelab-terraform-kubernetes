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

resource "random_password" "admin_password" {
  keepers = {
    version = var.admin_password_version
  }
  length      = 16
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

resource "postgresql_role" "nextcloud" {
  depends_on          = [random_password.db_password]
  login               = true
  name                = var.db_username
  password_wo         = local.db_password
  password_wo_version = var.db_password_version # Needs to be changed for password to be updated
}

resource "postgresql_database" "nextcloud" {
  depends_on = [postgresql_role.nextcloud]
  name       = var.db_name
  owner      = postgresql_role.nextcloud.id
}

resource "kubernetes_secret_v1" "nextcloud" {
  depends_on = [postgresql_database.nextcloud]
  metadata {
    namespace = var.namespace
    name      = "nextcloud"
  }
  data = {
    POSTGRES_HOST            = var.db_host
    POSTGRES_DB              = var.db_name
    POSTGRES_USER            = postgresql_role.nextcloud.name
    POSTGRES_PASSWORD        = postgresql_role.nextcloud.password_wo
    NEXTCLOUD_ADMIN_USERNAME = var.admin_username
    NEXTCLOUD_ADMIN_PASSWORD = local.admin_password
    SMTP_HOST                = var.smtp_host
    SMTP_PORT                = var.smtp_port
    SMTP_SECURE              = var.smtp_security
    SMTP_NAME                = var.smtp_username
    SMTP_PASSWORD            = var.smtp_password
    MAIL_FROM_ADDRESS        = var.smtp_from_email
    MAIL_DOMAIN              = var.smtp_from_name
  }
}

resource "kubernetes_persistent_volume_claim_v1" "nextcloud" {
  metadata {
    namespace = var.namespace
    name      = "nextcloud"
    labels = {
      app = "nextcloud"
    }
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

resource "kubernetes_deployment_v1" "nextcloud" {
  depends_on = [
    kubernetes_secret_v1.nextcloud,
    kubernetes_persistent_volume_claim_v1.nextcloud,
  ]
  metadata {
    namespace = var.namespace
    name      = "nextcloud"
    labels = {
      app = "nextcloud"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nextcloud"
      }
    }
    template {
      metadata {
        labels = {
          app = "nextcloud"
        }
      }
      spec {
        volume {
          name = "nextcloud"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.nextcloud.metadata[0].name
          }
        }
        container {
          name  = "nextcloud"
          image = "docker.io/library/nextcloud:${var.nextcloud_version}"
          volume_mount {
            name       = "nextcloud"
            mount_path = "/var/www/html"
          }
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.nextcloud.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "nextcloud" {
  depends_on = [kubernetes_deployment_v1.nextcloud]
  metadata {
    namespace = var.namespace
    name      = "nextcloud"
    labels = {
      app = "nextcloud"
    }
  }
  spec {
    selector = {
      app = "nextcloud"
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}

resource "kubernetes_manifest" "nextcloud_httproute" {
  depends_on = [kubernetes_service_v1.nextcloud]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "nextcloud"
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
          name = kubernetes_service_v1.nextcloud.metadata[0].name
          port = 80
        }]
      }]
    }
  }
}
