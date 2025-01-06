module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.17.0"

  function_name          = "${var.project}-${var.environment}"
  description            = var.description
  lambda_role            = var.lambda_role_arn
  handler                = var.handler
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
      path             = "${local.rel_path_root}/lambda_code/${split(var.handler, ".")[0]}",
      pip_requirements = true,
    }
  ]
  environment_variables = var.environment_variables
}
