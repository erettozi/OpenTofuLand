resource "random_string" "secrets" {
  length  = 17
  special = false
  upper   = true
  lower   = true
}

resource "aws_secretsmanager_secret" "database_password" {
  name = "exampleDatabasePassword-${var.env}-${random_string.secrets.result}"
}

resource "aws_secretsmanager_secret_version" "database_password_version" {
  secret_id     = aws_secretsmanager_secret.database_password.id
  secret_string = var.db_password
}