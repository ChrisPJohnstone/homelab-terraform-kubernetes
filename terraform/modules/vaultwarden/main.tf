# TODO: Create user and disable signups

resource "kubernetes_deployment_v1" "vaultwarden" {
  metadata {
    namespace = var.namespace
    name      = "vaultwarden"
    labels = {
      app = "vaultwarden"
    }
  }
  spec {
    replicas = 2
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
        container {
          name  = "vaultwarden"
          image = "docker.io/vaultwarden/server:${var.vaultwarden_version}"
          # TODO: Configure persistent storage
          env {
            name  = "I_REALLY_WANT_VOLATILE_STORAGE"
            value = true
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
