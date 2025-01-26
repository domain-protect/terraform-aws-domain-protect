variable "cloudflare_api_key" {
  description = "Cloudflare API token"
}

variable "cloudflare_email" {
  description = "Cloudflare Email"
}

variable "external_id" {
  description = "external ID for security audit role to be defined in tvars file. Leave empty if not configured"
}

variable "hackerone_api_token" {
  description = "HackerOne API token"
}

variable "org_primary_account" {
  description = "The AWS account number of the organization primary account"
}

variable "slack_webhook_urls" {
  description = "List of Slack webhook URLs, in the same order as the slack_channels list - enter in tfvars file"
  type        = list(string)
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
