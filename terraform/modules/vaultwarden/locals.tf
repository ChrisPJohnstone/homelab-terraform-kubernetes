locals {
  db_password = random_password.db_password.result
  admin_token = random_password.admin_token.result
  hostname    = "${var.subdomain}.${var.domain}"
}
