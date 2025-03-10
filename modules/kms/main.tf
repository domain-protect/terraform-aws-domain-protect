resource "aws_kms_key" "encryption" {
  description             = "Encryption of ${var.project}-${var.environment} resources"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = templatefile("${path.module}/templates/${var.kms_policy}.json.tpl", { account_id = data.aws_caller_identity.current.account_id, region = data.aws_region.current.name })
}

resource "aws_kms_alias" "encryption" {
  name          = "alias/${var.project}-${var.environment}"
  target_key_id = aws_kms_key.encryption.key_id
}
