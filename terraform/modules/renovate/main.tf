resource "kubernetes_secret_v1" "renovate" {
  metadata {
    namespace = var.namespace
    name      = "renovate-env"
  }
  data = {
    RENOVATE_AUTODISCOVER = "true"
    RENOVATE_ENDPOINT     = "https://api.github.com/"
    RENOVATE_TOKEN        = var.renovate_token
    RENOVATE_GIT_AUTHOR   = "Renovate <bot@renovateapp.com>"
    RENOVATE_PLATFORM     = "github"
  }
}

resource "kubernetes_manifest" "renovate" {
  depends_on = [kubernetes_secret_v1.renovate]
  manifest = {
    apiVersion = "batch/v1"
    kind       = "CronJob"
    metadata = {
      name      = "renovate"
      namespace = var.namespace
    }
    spec = {
      schedule          = "@hourly"
      concurrencyPolicy = "Forbid"
      jobTemplate = {
        spec = {
          template = {
            spec = {
              containers = [{
                name  = "renovate"
                image = "docker.io/renovate/renovate:${var.renovate_version}"
                args  = ["user/repo"]
                env = [{
                  name  = "LOG_LEVEL"
                  value = "debug"
                }]
                envFrom = [{ secretRef = { name = "renovate-env" } }]
              }]
              restartPolicy = "Never"
            }
          }
        }
      }
    }
  }
}
