# support separate plan and apply stages as in https://github.com/hashicorp/terraform-provider-archive/issues/39
resource "null_resource" "create_zip_every_time" {
  triggers = {
    always_run = timestamp()
  }
}

data "archive_file" "lambda_zip" {
  depends_on  = [null_resource.create_zip_every_time]
  type        = "zip"
  source_dir  = "${local.rel_path_root}/lambda_code/resources"
  output_path = "${local.rel_path_root}/build/resources.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = toset(var.lambdas)

  filename         = "${local.rel_path_root}/build/resources.zip"
  function_name    = "${var.project}-resources-${var.environment}"
  description      = "${var.project} lists resources created to prevent hostile takeover"
  role             = var.lambda_role_arn
  handler          = "resources.lambda_handler"
  kms_key_arn      = var.kms_arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = true

  environment {
    variables = {
      PROJECT       = var.project
      SNS_TOPIC_ARN = var.sns_topic_arn
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
