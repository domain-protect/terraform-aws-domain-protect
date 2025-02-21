variable "project" {}
variable "cloudflare_api_key" {}
variable "cloudflare_email" {}
variable "lambda_role_arn" {}
variable "kms_arn" {}
variable "lambdas" {}
variable "runtime" {}
variable "platform" {}
variable "memory_size" {}
variable "security_audit_role_name" {}
variable "external_id" {}
variable "org_primary_account" {}
variable "sns_topic_arn" {}
variable "dlq_sns_topic_arn" {}
variable "production_environment" {}
variable "bugcrowd" {}
variable "bugcrowd_api_key" {}
variable "bugcrowd_email" {}
variable "bugcrowd_state" {}
variable "hackerone" {}
variable "hackerone_api_token" {}

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

variable "state_machine_arn" {
  default = ""
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  default     = 900
}

variable "environment" {
  type = string
}
