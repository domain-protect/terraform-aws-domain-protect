module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.17.0"

  for_each = toset(var.lambdas)

  function_name          = "${var.project}-${each.value}-${var.environment}"
  description            = "${var.project} ${each.value} Lambda function"
  lambda_role            = var.lambda_role_arn
  handler                = "${replace(each.value, "-", "_")}.lambda_handler"
  kms_key_arn            = var.kms_arn
  runtime                = var.runtime
  memory_size            = var.memory_size
  timeout                = var.timeout
  dead_letter_target_arn = var.dlq_sns_topic_arn
  vpc_subnet_ids         = lookup(vpc_config, "subnet_ids", null)
  vpc_security_group_ids = lookup(vpc_config, "security_group_ids", null)
  publish                = true
  tracing_mode           = "Active"
  source_path = [
    {
      path             = "../lambda_code/${each.value}",
      pip_requirements = "requirements.txt",
    }
  ]
  environment_variables = {
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
