variable "project" {}

variable "environment" {}

variable "purpose" {
  description = "Purpose of secret, forms part of resource name"
}

variable "description" {
  description = "Description of secret"
  default     = ""
}

variable "kms_key_id" {
  description = "KMS key ID to encrypt the secret"
  default     = ""
}

variable "value" {
  description = "Secret value"
  default     = "dummy-value"
}

variable "tags" {
  type    = map(any)
  default = {}
}
