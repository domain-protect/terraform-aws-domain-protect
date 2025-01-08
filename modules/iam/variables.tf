variable "project" {}
variable "security_audit_role_name" {}
variable "kms_arn" {}

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

variable "takeover_managed_policy_names" {
  description = "Managed policy names to attach to the IAM role for takeover"
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
