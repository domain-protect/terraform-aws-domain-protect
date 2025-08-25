resource "random_string" "value" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "secret" {
  name        = "${lower(var.project)}-${lower(var.purpose)}-${lower(var.environment)}-${random_string.value.result}"
  description = var.description
  kms_key_id  = var.kms_key_id == "" ? null : var.kms_key_id
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "value" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.value

  lifecycle {
    ignore_changes = [secret_string]
  }
}
