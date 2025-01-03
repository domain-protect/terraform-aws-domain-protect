data "aws_region" "default" {}

module "kms" {
  source = "./modules/kms"

  project     = var.project
  region      = local.region
  environment = local.env
}

module "lambda_role" {
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "lambda_slack" {
  source = "./modules/lambda-slack"

  runtime            = local.runtime
  platform           = var.platform
  memory_size        = var.memory_size_slack
  project            = var.project
  lambda_role_arn    = module.lambda_role.lambda_role_arn
  kms_arn            = module.kms.kms_arn
  sns_topic_arn      = module.sns.sns_topic_arn
  dlq_sns_topic_arn  = module.sns_dead_letter_queue.sns_topic_arn
  slack_channels     = var.slack_channels
  slack_webhook_urls = var.slack_webhook_urls
  slack_webhook_type = var.slack_webhook_type
  slack_emoji        = var.slack_emoji
  slack_fix_emoji    = var.slack_fix_emoji
  slack_new_emoji    = var.slack_new_emoji
  slack_username     = var.slack_username
  environment        = local.env
  vpc_config         = var.vpc_config
}

module "lambda" {
  source = "./modules/lambda"

  lambdas                  = var.lambdas
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  lambda_role_arn          = module.lambda_role.lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  state_machine_arn        = module.step_function.state_machine_arn
  allowed_regions          = var.allowed_regions
  ip_time_limit            = var.ip_time_limit
  environment              = local.env
  vpc_config               = var.vpc_config
}

module "lambda_accounts" {
  source = "./modules/lambda-accounts"

  lambdas                  = ["accounts"]
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  lambda_role_arn          = module.accounts_role.lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  state_machine_arn        = module.step_function.state_machine_arn
  environment              = local.env
  vpc_config               = var.vpc_config
}

module "accounts_role" {
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  state_machine_arn        = module.step_function.state_machine_arn
  policy                   = "accounts"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "lambda_scan" {
  source = "./modules/lambda-scan"

  lambdas                  = ["scan"]
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  lambda_role_arn          = module.lambda_role.lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  bugcrowd                 = var.bugcrowd
  bugcrowd_api_key         = var.bugcrowd_api_key
  bugcrowd_email           = var.bugcrowd_email
  bugcrowd_state           = var.bugcrowd_state
  hackerone                = var.hackerone
  hackerone_api_token      = var.hackerone_api_token
  environment              = local.env
  production_environment   = local.production_environment
  vpc_config               = var.vpc_config
}

module "lambda_takeover" {
  #checkov:skip=CKV_AWS_274:role is ElasticBeanstalk admin, not full Administrator Access
  count  = var.takeover ? 1 : 0
  source = "./modules/lambda-takeover"

  runtime           = local.runtime
  platform          = var.platform
  memory_size       = var.memory_size_slack
  project           = var.project
  lambda_role_arn   = one(module.takeover_role[*].lambda_role_arn)
  kms_arn           = module.kms.kms_arn
  sns_topic_arn     = module.sns.sns_topic_arn
  dlq_sns_topic_arn = module.sns_dead_letter_queue.sns_topic_arn
  environment       = local.env
  vpc_config        = var.vpc_config
}

module "takeover_role" {
  count  = var.takeover ? 1 : 0
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  takeover                 = var.takeover
  policy                   = "takeover"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "lambda_resources" {
  count  = var.takeover ? 1 : 0
  source = "./modules/lambda-resources"

  lambdas           = ["resources"]
  runtime           = local.runtime
  memory_size       = var.memory_size_slack
  project           = var.project
  lambda_role_arn   = one(module.resources_role[*].lambda_role_arn)
  kms_arn           = module.kms.kms_arn
  sns_topic_arn     = module.sns.sns_topic_arn
  dlq_sns_topic_arn = module.sns_dead_letter_queue.sns_topic_arn
  environment       = local.env
  vpc_config        = var.vpc_config
}

module "resources_role" {
  count  = var.takeover ? 1 : 0
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  policy                   = "resources"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "cloudwatch_event" {
  source = "./modules/cloudwatch"

  project                     = var.project
  lambda_function_arns        = module.lambda.lambda_function_arns
  lambda_function_names       = module.lambda.lambda_function_names
  lambda_function_alias_names = module.lambda.lambda_function_alias_names
  schedule                    = var.reports_schedule
  takeover                    = var.takeover
  update_schedule             = var.update_schedule
  update_lambdas              = var.update_lambdas
  environment                 = local.env
}

module "resources_event" {
  count  = var.takeover ? 1 : 0
  source = "./modules/cloudwatch"

  project                     = var.project
  lambda_function_arns        = module.lambda_resources[0].lambda_function_arns
  lambda_function_names       = module.lambda_resources[0].lambda_function_names
  lambda_function_alias_names = module.lambda_resources[0].lambda_function_alias_names
  schedule                    = var.reports_schedule
  takeover                    = var.takeover
  update_schedule             = var.scan_schedule
  update_lambdas              = var.update_lambdas
  environment                 = local.env
}

module "accounts_event" {
  source = "./modules/cloudwatch"

  project                     = var.project
  lambda_function_arns        = module.lambda_accounts.lambda_function_arns
  lambda_function_names       = module.lambda_accounts.lambda_function_names
  lambda_function_alias_names = module.lambda_accounts.lambda_function_alias_names
  schedule                    = var.scan_schedule
  takeover                    = var.takeover
  update_schedule             = var.scan_schedule
  update_lambdas              = var.update_lambdas
  environment                 = local.env
}

module "sns" {
  source = "./modules/sns"

  project     = var.project
  region      = local.region
  kms_arn     = module.kms.kms_arn
  environment = local.env
}

module "sns_dead_letter_queue" {
  source = "./modules/sns"

  project           = var.project
  region            = local.region
  dead_letter_queue = true
  kms_arn           = module.kms.kms_arn
  environment       = local.env
}

module "lambda_cloudflare" {
  count  = var.cloudflare ? 1 : 0
  source = "./modules/lambda-cloudflare"

  lambdas                  = var.cloudflare_lambdas
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  cf_api_key               = var.cf_api_key
  lambda_role_arn          = module.lambda_role.lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  production_environment   = local.production_environment
  bugcrowd                 = var.bugcrowd
  bugcrowd_api_key         = var.bugcrowd_api_key
  bugcrowd_email           = var.bugcrowd_email
  bugcrowd_state           = var.bugcrowd_state
  hackerone                = var.hackerone
  hackerone_api_token      = var.hackerone_api_token
  environment              = local.env
  vpc_config               = var.vpc_config
}

module "cloudflare_event" {
  count  = var.cloudflare ? 1 : 0
  source = "./modules/cloudwatch"

  project                     = var.project
  lambda_function_arns        = module.lambda_cloudflare[0].lambda_function_arns
  lambda_function_names       = module.lambda_cloudflare[0].lambda_function_names
  lambda_function_alias_names = module.lambda_cloudflare[0].lambda_function_alias_names
  schedule                    = var.scan_schedule
  takeover                    = var.takeover
  update_schedule             = var.scan_schedule
  update_lambdas              = var.update_lambdas
  environment                 = local.env
}

module "dynamodb" {
  source  = "./modules/dynamodb"
  project = var.project

  kms_arn     = module.kms.kms_arn
  rcu         = var.rcu
  wcu         = var.wcu
  environment = local.env
}

module "step_function_role" {
  source  = "./modules/iam"
  project = var.project

  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  policy                   = "state"
  assume_role_policy       = "state"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "step_function" {
  source  = "./modules/step-function"
  project = var.project

  lambda_arn  = module.lambda_scan.lambda_function_arns["scan"]
  role_arn    = module.step_function_role.lambda_role_arn
  kms_arn     = module.kms.kms_arn
  environment = local.env
}

module "dynamodb_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/dynamodb-ips"

  project     = var.project
  kms_arn     = module.kms.kms_arn
  environment = local.env
}

module "step_function_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/step-function"

  project     = var.project
  purpose     = "ips"
  lambda_arn  = module.lambda_scan_ips[0].lambda_function_arns["scan-ips"]
  role_arn    = module.step_function_role.lambda_role_arn
  kms_arn     = module.kms.kms_arn
  environment = local.env
}

module "lambda_role_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  policy                   = "lambda"
  role_name                = "lambda-ips"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "lambda_scan_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/lambda-scan-ips"

  lambdas                  = ["scan-ips"]
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  lambda_role_arn          = module.lambda_role_ips[0].lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  production_environment   = local.production_environment
  allowed_regions          = var.allowed_regions
  ip_time_limit            = var.ip_time_limit
  bugcrowd                 = var.bugcrowd
  bugcrowd_api_key         = var.bugcrowd_api_key
  bugcrowd_email           = var.bugcrowd_email
  bugcrowd_state           = var.bugcrowd_state
  hackerone                = var.hackerone
  hackerone_api_token      = var.hackerone_api_token
  environment              = local.env
  vpc_config               = var.vpc_config
}

module "accounts_role_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/iam"

  project                  = var.project
  region                   = local.region
  security_audit_role_name = var.security_audit_role_name
  kms_arn                  = module.kms.kms_arn
  state_machine_arn        = module.step_function_ips[0].state_machine_arn
  policy                   = "accounts"
  role_name                = "accounts-ips"
  permissions_boundary_arn = var.permissions_boundary_arn
  environment              = local.env
}

module "lambda_accounts_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/lambda-accounts"

  lambdas                  = ["accounts-ips"]
  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  org_primary_account      = var.org_primary_account
  lambda_role_arn          = module.accounts_role_ips[0].lambda_role_arn
  kms_arn                  = module.kms.kms_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  state_machine_arn        = module.step_function_ips[0].state_machine_arn
  environment              = local.env
  vpc_config               = var.vpc_config
}

module "accounts_event_ips" {
  count  = var.ip_address ? 1 : 0
  source = "./modules/cloudwatch"

  project                     = var.project
  lambda_function_arns        = module.lambda_accounts_ips[0].lambda_function_arns
  lambda_function_names       = module.lambda_accounts_ips[0].lambda_function_names
  lambda_function_alias_names = module.lambda_accounts_ips[0].lambda_function_alias_names
  schedule                    = var.ip_scan_schedule
  takeover                    = var.takeover
  update_schedule             = var.ip_scan_schedule
  update_lambdas              = var.update_lambdas
  environment                 = local.env
}

module "lamdba_stats" {
  source = "./modules/lambda-stats"

  runtime                  = local.runtime
  platform                 = var.platform
  memory_size              = var.memory_size
  project                  = var.project
  kms_arn                  = module.kms.kms_arn
  lambda_role_arn          = module.lambda_role.lambda_role_arn
  sns_topic_arn            = module.sns.sns_topic_arn
  dlq_sns_topic_arn        = module.sns_dead_letter_queue.sns_topic_arn
  schedule_expression      = var.stats_schedule
  org_primary_account      = var.org_primary_account
  security_audit_role_name = var.security_audit_role_name
  external_id              = var.external_id
  environment              = local.env
  vpc_config               = var.vpc_config
}
