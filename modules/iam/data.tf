data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "default" {
  for_each = var.takeover ? toset(var.managed_policy_names) : toset([])
  name     = each.value
}
