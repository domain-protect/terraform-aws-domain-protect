variable "cloudflare_api_key" {
  description = "Cloudflare API token"
}

variable "cloudflare_email" {
  description = "Cloudflare Email"
}

variable "hackerone_api_token" {
  description = "HackerOne API token"
}

variable "org_primary_account" {
  description = "The AWS account number of the organization primary account"
}

variable "region" {
  description = "AWS region to deploy resources into"
  default     = "eu-west-1"
  type        = string
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
