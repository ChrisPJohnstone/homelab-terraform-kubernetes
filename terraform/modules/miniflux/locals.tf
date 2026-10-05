locals {
  db_password = random_password.db_user_password.result
  hostname    = "${var.subdomain}.${var.domain}"
}
