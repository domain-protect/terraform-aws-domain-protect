variable "scan_schedule" {
  description = "schedule for running domain-protect scans, e.g. 24 hours"
  default     = "24 hours"
  type        = string
}

variable "update_schedule" {
  description = "schedule for running domain-protect update function, e.g. 24 hours"
  default     = "24 hours"
  type        = string
}

variable "ip_scan_schedule" {
  description = "schedule for IP address scanning used in A record checks"
  default     = "24 hours"
  type        = string
}

variable "takeover" {
  description = "Create supported resource types to prevent malicious subdomain takeover"
  default     = false
  type        = bool
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
