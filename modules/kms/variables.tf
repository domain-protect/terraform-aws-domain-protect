variable "project" {}

variable "kms_policy" {
  description = "KMS policy to use"
  default     = "default"
}

variable "environment" {
  type = string
}
