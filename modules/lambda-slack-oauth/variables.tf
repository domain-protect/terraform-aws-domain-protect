variable "project" {}
variable "lambda_role_arn" {}
variable "kms_arn" {}
variable "runtime" {}
variable "platform" {}
variable "memory_size" {}
variable "sns_topic_arn" {}
variable "dlq_sns_topic_arn" {}
variable "oauth_secret_arn" {}
variable "slack_channels" {}
variable "slack_emoji" {}
variable "slack_fix_emoji" {}
variable "slack_new_emoji" {}
variable "slack_username" {}

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

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  default     = 900
}

variable "environment" {
  type = string
}
