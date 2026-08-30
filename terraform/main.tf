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

# TODO: Set up database
# TODO: Set up service
# resource "kubernetes_deployment_v1" "miniflux" {
#   depends_on = [kubernetes_namespace_v1.namespace]
#   metadata {
#     name = "minifix"
#     labels = {
#       app = "miniflux"
#     }
#   }
#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         app = "miniflux"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "miniflux"
#         }
#       }
#       spec {
#         container {
#           name  = "miniflux"
#           image = "docker.io/miniflux/miniflux:latest"
#           env {
#             name  = "DATABASE_URL"
#             value = "postgres://miniflux:*password*@*dbhost*/miniflux?sslmode=disable"
#           }
#           env {
#             name  = "RUN_MIGRATIONS"
#             value = "1"
#           }
#           env {
#             name  = "CREATE_ADMIN"
#             value = "1"
#           }
#           env {
#             name  = "ADMIN_USERNAME"
#             value = "*username*"
#           }
#           env {
#             name  = "ADMIN_PASSWORD"
#             value = "*password*"
#           }
#         }
#       }
#     }
#   }
# }
