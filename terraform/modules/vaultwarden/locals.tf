locals {
  db_password = random_password.db_password.result
  hostname    = "${var.subdomain}.${var.domain}"
}
