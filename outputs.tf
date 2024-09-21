output "kms" {
  value       = module.kms
  description = "Outputs of module.kms"
}

output "lambda_role" {
  value       = module.lambda_role
  description = "Outputs of module.lambda_role"
}

output "lambda_slack" {
  value       = module.lambda_slack
  description = "Outputs of module.lambda_slack"
}

output "lambda" {
  value       = module.lambda
  description = "Outputs of module.lambda"
}

output "lambda_accounts" {
  value       = module.lambda_accounts
  description = "Outputs of module.lambda_accounts"
}

output "accounts_role" {
  value       = module.accounts_role
  description = "Outputs of module.accounts_role"
}

output "lambda_scan" {
  value       = module.lambda_scan
  description = "Outputs of module.lambda_scan"
}

output "lambda_takeover" {
  value       = var.takeover ? module.lambda_takeover : []
  description = "Outputs of module.lambda_takeover"
}

output "takeover_role" {
  value       = var.takeover ? module.takeover_role : []
  description = "Outputs of module.takeover_role"
}

output "lambda_resources" {
  value       = var.takeover ? module.lambda_resources : []
  description = "Outputs of module.lambda_resources"
}

output "resources_role" {
  value       = var.takeover ? module.resources_role : []
  description = "Outputs of module.resources_role"
}

output "cloudwatch_event" {
  value       = module.cloudwatch_event
  description = "Outputs of module.cloudwatch_event"
}

output "resources_event" {
  value       = var.takeover ? module.resources_event : []
  description = "Outputs of module.resources_event"
}

output "accounts_event" {
  value       = module.accounts_event
  description = "Outputs of module.accounts_event"
}

output "sns" {
  value       = module.sns
  description = "Outputs of module.sns"
}

output "sns_dead_letter_queue" {
  value       = module.sns_dead_letter_queue
  description = "Outputs of module.sns_dead_letter_queue"
}

output "lambda_cloudflare" {
  value       = var.cloudflare ? module.lambda_cloudflare : []
  description = "Outputs of module.lambda_cloudflare"
}

output "cloudflare_event" {
  value       = var.cloudflare ? module.cloudflare_event : []
  description = "Outputs of module.cloudflare_event"
}

output "dynamodb" {
  value       = module.dynamodb
  description = "Outputs of module.dynamodb"
}

output "step_function_role" {
  value       = module.step_function_role
  description = "Outputs of module.step_function_role"
}

output "step_function" {
  value       = module.step_function
  description = "Outputs of module.step_function"
}

output "dynamodb_ips" {
  value       = var.ip_address ? module.dynamodb_ips : []
  description = "Outputs of module.dynamodb_ips"
}

output "step_function_ips" {
  value       = var.ip_address ? module.step_function_ips : []
  description = "Outputs of module.step_function_ips"
}

output "lambda_role_ips" {
  value       = var.ip_address ? module.lambda_role_ips : []
  description = "Outputs of module.lambda_role_ips"
}

output "lambda_scan_ips" {
  value       = var.ip_address ? module.lambda_scan_ips : []
  description = "Outputs of module.lambda_scan_ips"
}

output "accounts_role_ips" {
  value       = var.ip_address ? module.accounts_role_ips : []
  description = "Outputs of module.accounts_role_ips"
}

output "lambda_accounts_ips" {
  value       = var.ip_address ? module.lambda_accounts_ips : []
  description = "Outputs of module.lambda_accounts_ips"
}

output "accounts_event_ips" {
  value       = var.ip_address ? module.accounts_event_ips : []
  description = "Outputs of module.accounts_event_ips"
}

output "lamdba_stats" {
  value       = module.lamdba_stats
  description = "Outputs of module.lamdba_stats"
}
