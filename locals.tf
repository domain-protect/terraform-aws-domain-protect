locals {
  env = coalesce(var.environment, lower(terraform.workspace))

  runtime = coalesce(var.runtime, format("python%s", regex("^\\d+\\.\\d+", file("${path.module}/python-version"))))
}
