variable "allowed_regions" {
  description = "If SCPs block certain regions across all accounts, optional list of allowed regions"
  default     = ["all"] # example ["eu-west-1", "us-east-1"]
  type        = list(string)
}

variable "aws_ip_addresses" {
  description = "Authorised AWS IPv4 addresses or networks outside AWS Organization"
  default     = []
  type        = list(string)
}

variable "bugcrowd" {
  description = "Set to enabled for Bugcrowd integration"
  default     = "disabled"
  type        = string
}

variable "bugcrowd_api_key" {
  description = "Bugcrowd API token"
  default     = ""
  type        = string
  sensitive   = true
}

variable "bugcrowd_email" {
  description = "Email address of Bugcrowd researcher service account"
  default     = ""
  type        = string
}

variable "bugcrowd_state" {
  description = "State in which issue is created, e.g. new, triaged, unresolved, resolved"
  default     = "unresolved"
  type        = string
}

variable "cloudflare" {
  description = "Set to true to enable CloudFlare"
  default     = false
  type        = bool
}

variable "cloudflare_api_key" {
  description = "Cloudflare API token"
  default     = ""
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "Cloudflare Email"
  default     = ""
  type        = string
}

variable "cloudflare_lambdas" {
  description = "list of names of Lambda files in the lambda-cloudflare/code folder"
  default     = ["cloudflare-scan"]
  type        = list(any)
}

variable "deploy_audit_role" {
  description = "Whether to deploy domain protect audit role in all accounts except management account"
  default     = true
  type        = bool
}

variable "environment" {
  description = "Environment deploying to, defaults to terraform.workspace - optionally enter in tfvars file"
  default     = ""
  type        = string
}

variable "external_id" {
  description = "external ID for security audit role to be defined in tvars file. Leave empty if not configured"
  default     = ""
  type        = string
}

variable "hackerone" {
  description = "Set to enabled for HackerOne integration"
  default     = "disabled"
  type        = string
}

variable "hackerone_api_token" {
  description = "HackerOne API token"
  default     = ""
  type        = string
  sensitive   = true
}

variable "ip_address" {
  description = "Whether to enable A record checks using IP address scans"
  default     = true
  type        = bool
}

variable "ip_scan_schedule" {
  description = "schedule for IP address scanning used in A record checks"
  default     = "24 hours"
  type        = string
}

variable "ip_time_limit" {
  description = "maximum time in hours since IP last detected, before considering IP as no longer belonging to organisation"
  default     = "48"
  type        = string
}

variable "lambdas" {
  description = "list of names of Lambda files in the lambda/code folder"
  default     = ["current", "update"]
  type        = list(any)
}

variable "memory_size" {
  description = "Memory allocation for scanning Lambda functions"
  default     = 128
  type        = number
}

variable "memory_size_large" {
  description = "Memory allocation for compute heavy Lambda functions"
  default     = 512
  type        = number
}

variable "memory_size_medium" {
  description = "Memory allocation for medium compute Lambda functions"
  default     = 256
  type        = number
}

variable "misconfigured" {
  description = "Enable detection of misconfigured DNS"
  default     = true
  type        = bool
}

variable "org_primary_account" {
  description = "The AWS account number of the organization primary account"
  type        = string
}

variable "permissions_boundary_arn" {
  description = "permissions boundary ARN to attach to every IAM role"
  default     = null
  type        = string
}

variable "platform" {
  description = "Python platform used for install of Regex and other libraries"
  default     = "manylinux2014_x86_64"
  type        = string
}

variable "policy_name" {
  description = "Name of IAM policy to be created in all accounts"
  default     = "domain-protect"
  type        = string
}

variable "production_environment" {
  description = "Name of production environment - takeover is only turned on in this environment"
  default     = "prd"
  type        = string
}

variable "project" {
  description = "abbreviation for the project, forms first part of resource names"
  default     = "domain-protect"
  type        = string
}

variable "rcu" {
  description = "DynamoDB Read Capacity Units for vulnerability database"
  default     = 3
  type        = number
}

variable "reports_schedule" {
  description = "schedule for running reports, e.g. 24 hours. Irrespective of setting, you will be immediately notified of new vulnerabilities. Also used for misconfigured DNS checks"
  default     = "24 hours"
  type        = string
}

variable "runtime" {
  description = "Lambda language runtime. Defaults to the `python-version` in repo and can be overridden."
  default     = ""
  type        = string
}

variable "scan_schedule" {
  description = "schedule for running domain-protect scans, e.g. 24 hours"
  default     = "24 hours"
  type        = string
}

variable "security_audit_role_name" {
  description = "security audit role name which needs to be the same in all AWS accounts"
  default     = "domain-protect-audit"
  type        = string
}

variable "slack_channels" {
  description = "List of Slack Channels - enter in tfvars file"
  default     = []
  type        = list(string)
}

variable "slack_emoji" {
  description = "Slack emoji"
  default     = ":warning:"
  type        = string
}

variable "slack_fix_emoji" {
  description = "Slack fix emoji"
  default     = ":white_check_mark:"
  type        = string
}

variable "slack_new_emoji" {
  description = "Slack emoji for new vulnerability"
  default     = ":octagonal_sign:"
  type        = string
}

variable "slack_oauth_app" {
  description = "Use Slack OAuth App"
  default     = true
  type        = bool
}

variable "slack_username" {
  description = "Slack username appearing in the from field in the Slack message"
  default     = "Domain Protect"
  type        = string
}

variable "slack_webhook_type" {
  description = "Slack webhook type, can be legacy or app - not needed for OAuth"
  default     = "legacy"
  type        = string
}

variable "slack_webhook_urls" {
  description = "List of Slack webhook URLs, in the same order as the slack_channels list - not needed for OAuth"
  default     = []
  type        = list(string)
}

variable "stackset_name" {
  description = "Name of CloudFormation StackSet"
  default     = "domain-protect"
  type        = string
}

variable "stats_schedule" {
  description = "Cron schedule for the stats message"
  default     = "cron(0 9 1 * ? *)" # 9am on the first of the month
  type        = string
}

variable "takeover" {
  description = "Create supported resource types to prevent malicious subdomain takeover"
  default     = false
  type        = bool
}

variable "update_lambdas" {
  description = "list of Cloudflare Lambda functions updating vulnerability status"
  default     = ["update"]
  type        = list(any)
}

variable "update_schedule" {
  description = "schedule for running domain-protect update function, e.g. 24 hours"
  default     = "24 hours"
  type        = string
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  description = <<EOF
  Provide this to allow your function to access your VPC (if both 'subnet_ids' and 'security_group_ids' are empty then
  vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details).
  EOF
  default     = null
}

variable "wcu" {
  description = "DynamoDB Write Capacity Units for vulnerability database"
  default     = 2
  type        = number
}
