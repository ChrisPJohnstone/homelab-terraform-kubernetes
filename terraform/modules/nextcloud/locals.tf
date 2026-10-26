locals {
  db_password    = random_password.db_password.result
  admin_password = random_password.admin_password.result
  hostname       = "${var.subdomain}.${var.domain}"
}
