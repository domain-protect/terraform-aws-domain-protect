locals {
  env                    = coalesce(var.environment, lower(terraform.workspace))
  production_environment = coalesce(var.production_environment, var.production_workspace)

  runtime = coalesce(var.runtime, format("python%s", regex("^\\d+\\.\\d+", file("${path.module}/python-version"))))
  region  = var.region != "" ? var.region : data.aws_region.default.name

  lambda_config = {
    accounts = {
      handler     = "accounts.lambda_handler"
      description = "${var.project} Accounts Lambda function"
      environment_variables = {
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        PROJECT                  = var.project
        SNS_TOPIC_ARN            = module.sns.sns_topic_arn
        ENVIRONMENT              = var.environment
        STATE_MACHINE_ARN        = module.step_function.state_machine_arn
      }
    }
    accounts_ips = {
      handler     = "accounts_ips.lambda_handler"
      description = "${var.project} Accounts IPs Lambda function"
      environment_variables = {
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        PROJECT                  = var.project
        STATE_MACHINE_ARN        = module.step_function_ips[0].state_machine_arn
      }
    }
    cloudflare = {
      handler = "cloudflare_scan.lambda_handler"
      environment_variables = {
        CF_API_KEY               = var.cf_api_key
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        PROJECT                  = var.project
        SNS_TOPIC_ARN            = module.sns.sns_topic_arn
        ENVIRONMENT              = var.environment
        PRODUCTION_ENVIRONMENT   = var.production_environment
        BUGCROWD                 = var.bugcrowd
        BUGCROWD_API_KEY         = var.bugcrowd_api_key
        BUGCROWD_EMAIL           = var.bugcrowd_email
        BUGCROWD_STATE           = var.bugcrowd_state
        HACKERONE                = var.hackerone
        HACKERONE_API_TOKEN      = var.hackerone_api_token
      }
    }
    current = {
      handler     = "current.lambda_handler"
      description = "${var.project} lists current resources"
      environment_variables = {
        PROJECT       = var.project
        SNS_TOPIC_ARN = module.sns.sns_topic_arn
      }
    }
    resources = {
      handler     = "resources.lambda_handler"
      description = "${var.project} lists resources created to prevent hostile takeover"
      environment_variables = {
        PROJECT       = var.project
        SNS_TOPIC_ARN = module.sns.sns_topic_arn
      }
    }
    scan = {
      handler     = "scan.lambda_handler"
      description = "${var.project} Scan Lambda function"
      environment_variables = {
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        PROJECT                  = var.project
        SNS_TOPIC_ARN            = module.sns.sns_topic_arn
        ENVIRONMENT              = var.environment
        PRODUCTION_ENVIRONMENT   = var.production_environment
        BUGCROWD                 = var.bugcrowd
        BUGCROWD_API_KEY         = var.bugcrowd_api_key
        BUGCROWD_EMAIL           = var.bugcrowd_email
        BUGCROWD_STATE           = var.bugcrowd_state
        HACKERONE                = var.hackerone
        HACKERONE_API_TOKEN      = var.hackerone_api_token
      }
    }
    scan_ips = {
      handler     = "scan_ips.lambda_handler"
      description = "${var.project} Scan IPs Lambda function"
      environment_variables = {
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        PROJECT                  = var.project
        SNS_TOPIC_ARN            = module.sns.sns_topic_arn
        ENVIRONMENT              = var.environment
        PRODUCTION_ENVIRONMENT   = var.production_environment
        ALLOWED_REGIONS          = var.allowed_regions
        IP_TIME_LIMIT            = var.ip_time_limit
        BUGCROWD                 = var.bugcrowd
        BUGCROWD_API_KEY         = var.bugcrowd_api_key
        BUGCROWD_EMAIL           = var.bugcrowd_email
        BUGCROWD_STATE           = var.bugcrowd_state
        HACKERONE                = var.hackerone
        HACKERONE_API_TOKEN      = var.hackerone_api_token
      }
    }
    slack = {
      handler     = "notify.lambda_handler"
      description = "${var.project} Lambda function posting to ${element(var.slack_channels, count.index)} Slack channel"
      environment_variables = {
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
    stats = {
      handler     = "stats.lambda_handler"
      description = "${var.project} Lambda function posting stats to SNS"
      environment_variables = {
        PROJECT                  = var.project
        ENVIRONMENT              = var.environment
        ORG_PRIMARY_ACCOUNT      = var.org_primary_account
        SECURITY_AUDIT_ROLE_NAME = var.security_audit_role_name
        EXTERNAL_ID              = var.external_id
        SNS_TOPIC_ARN            = module.sns.sns_topic_arn
      }
    }
    takeover = {
      handler     = "takeover.lambda_handler"
      description = "${var.project} Lambda function to takeover vulnerable resources"
      environment_variables = {
        PROJECT       = var.project
        SNS_TOPIC_ARN = module.sns.sns_topic_arn
        SUFFIX        = random_string.suffix.result
        ENVIRONMENT   = var.environment
      }
    }
    update = {
      handler     = "update.lambda_handler"
      description = "${var.project} Lambda function to update vulnerable resources"
      environment_variables = {
        PROJECT       = var.project
        SNS_TOPIC_ARN = module.sns.sns_topic_arn
        ENVIRONMENT   = var.environment
      }
    }
  }
}
