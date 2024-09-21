locals {
  env                    = coalesce(var.environment, lower(terraform.workspace))
  production_environment = coalesce(var.production_environment, var.production_workspace)

  runtime = coalesce(var.runtime, format("python%s", regex("^\\d+\\.\\d+", file("${path.module}/.python-version"))))
}
