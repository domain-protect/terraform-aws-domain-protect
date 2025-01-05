output "lambda_function_arns" {
  value = module.lambda_function.*.lambda_function_arn
}

output "lambda_function_names" {
  value = module.lambda_function.*.lambda_function_name
}

output "lambda_function_alias_names" {
  value = module.lambda_function.*.lambda_function_qualified_arn
}
