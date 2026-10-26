resource "kubernetes_manifest" "renovate" {
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
                image = "renovate/renovate:${var.renovate_version}"
                args  = ["user/repo"]
                env = [{
                  name  = "LOG_LEVEL"
                  value = "debug"
                }]
                envFrom = [{
                  secretRef = {
                    name = "renovate-env"
                  }
                }]
              }]
              restartPolicy = "Never"
            }
          }
        }
      }
    }
  }
}
