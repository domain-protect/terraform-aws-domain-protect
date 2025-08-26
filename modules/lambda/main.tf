resource "null_resource" "install_python_dependencies" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
      chmod +x ${local.rel_path_root}/scripts/lambda-build/create-package-for-each.sh
      ${local.rel_path_root}/scripts/lambda-build/create-package-for-each.sh
    EOT

    environment = {
      source_code_path = "${local.rel_path_root}/lambda_code"
      function_names   = join(":", [for l in var.lambdas : replace(l, "-", "_")])
      runtime          = var.runtime
      platform         = var.platform
      path_cwd         = local.rel_path_root
    }
  }
}

data "archive_file" "lambda_zip" {
  for_each = toset([for l in var.lambdas : replace(l, "-", "_")])

  depends_on  = [null_resource.install_python_dependencies]
  type        = "zip"
  source_dir  = "${local.rel_path_root}/build/lambda_dist_pkg_${each.value}"
  output_path = "${local.rel_path_root}/build/${each.value}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = toset(var.lambdas)

  filename         = "${local.rel_path_root}/build/${replace(each.value, "-", "_")}.zip"
  function_name    = "${var.project}-${each.value}-${var.environment}"
  description      = "${var.project} ${each.value} Lambda function"
  role             = var.lambda_role_arn
  handler          = "${replace(each.value, "-", "_")}.lambda_handler"
  kms_key_arn      = var.kms_arn
  source_code_hash = data.archive_file.lambda_zip[replace(each.value, "-", "_")].output_base64sha256
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = true

  environment {
    variables = {
      ORG_PRIMARY_ACCOUNT      = var.org_primary_account
      SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
      EXTERNAL_ID              = var.external_id
      PROJECT                  = var.project
      SNS_TOPIC_ARN            = var.sns_topic_arn
      ENVIRONMENT              = var.environment
      ALLOWED_REGIONS          = var.allowed_regions
      IP_TIME_LIMIT            = var.ip_time_limit
    }
  }

  dead_letter_config {
    target_arn = var.dlq_sns_topic_arn
  }

  tracing_config {
    mode = "Active"
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }
}

resource "aws_lambda_alias" "lambda" {
  for_each = toset(var.lambdas)

  name             = "${var.project}-${each.value}-${var.environment}"
  description      = "Alias for ${var.project}-${each.value}s-${var.environment}"
  function_name    = aws_lambda_function.lambda[each.key].function_name
  function_version = "$LATEST"
}
