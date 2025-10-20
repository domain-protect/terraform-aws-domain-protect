variable "policy_name" {
  description = "Name of IAM policy to be created in all accounts"
}

variable "project" {
  description = "abbreviation for the project, forms first part of resource names"
}

variable "role_name" {
  description = "Name of IAM role to be created in all accounts"
}

variable "stackset_name" {
  description = "Name of CloudFormation StackSet"
}
