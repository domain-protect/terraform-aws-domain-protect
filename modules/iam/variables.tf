variable "project" {}

variable "kms_arn" {}

variable "secret_arn" {
  description = "Secret ARN"
  default     = ""
}

variable "security_audit_role_name" {
  description = "Security audit role name"
  default     = ""
}

variable "state_machine_arn" {
  description = "Step Function state machine ARN"
  default     = ""
}

variable "assume_role_policy" {
  description = "Assume role policy template to use"
  default     = "lambda"
}

variable "policy" {
  description = "policy template to use"
  default     = "lambda"
}

variable "managed_policy_names" {
  description = "Managed policy names to attach to the IAM role"
  default = [
    "AdministratorAccess-AWSElasticBeanstalk",
    "AWSCloudFormationFullAccess",
    "AmazonS3FullAccess",
    "AmazonVPCFullAccess",
  ]
}

variable "takeover" {
  description = "include managed policies to enable takeover"
  default     = false
}

variable "role_name" {
  description = "role name if different from policy name"
  default     = "policyname"
}

variable "permissions_boundary_arn" {
  description = "permissions boundary ARN"
  default     = null
}

variable "environment" {
  type = string
}
