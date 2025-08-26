data "archive_file" "lambda_zip" {
  depends_on  = [null_resource.install_python_dependencies]
  type        = "zip"
  source_dir  = "${local.rel_path_root}/build/lambda_dist_pkg_notify"
  output_path = "${local.rel_path_root}/build/notify.zip"
}

resource "null_resource" "install_python_dependencies" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
      chmod +x ${local.rel_path_root}/scripts/lambda-build/create-package.sh
      ${local.rel_path_root}/scripts/lambda-build/create-package.sh
    EOT

    environment = {
      source_code_path = "${local.rel_path_root}/lambda_code"
      function_name    = "notify"
      path_module      = path.module
      runtime          = var.runtime
      platform         = var.platform
      path_cwd         = local.rel_path_root
    }
  }
}

resource "aws_lambda_function" "lambda" {
  count            = length(var.slack_channels)
  filename         = "${local.rel_path_root}/build/notify.zip"
  function_name    = "${var.project}-slack-${element(var.slack_channels, count.index)}-${var.environment}"
  description      = "${var.project} Lambda function posting to ${element(var.slack_channels, count.index)} Slack channel"
  role             = var.lambda_role_arn
  handler          = "notify.lambda_handler"
  kms_key_arn      = var.kms_arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = true

  environment {
    variables = {
      SLACK_CHANNEL      = element(var.slack_channels, count.index)
      SLACK_WEBHOOK_URL  = element(var.slack_webhook_urls, count.index)
      SLACK_WEBHOOK_TYPE = var.slack_webhook_type
      SLACK_EMOJI        = var.slack_emoji
      SLACK_FIX_EMOJI    = var.slack_fix_emoji
      SLACK_NEW_EMOJI    = var.slack_new_emoji
      SLACK_USERNAME     = var.slack_username
      PROJECT            = var.project
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
  count            = length(var.slack_channels)
  name             = "${var.project}-slack-${var.slack_channels[count.index]}-${var.environment}"
  description      = "Alias for ${var.project}-${element(var.slack_channels, count.index)}-${var.environment}"
  function_name    = aws_lambda_function.lambda[count.index].function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "sns" {
  count         = length(var.slack_channels)
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[count.index].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  count     = length(var.slack_channels)
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda[count.index].arn
}
