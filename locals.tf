locals {
  env                    = coalesce(var.environment, lower(terraform.workspace))
  production_environment = coalesce(var.production_environment, var.production_workspace)
}
