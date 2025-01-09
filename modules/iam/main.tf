locals {
  role_name = format(
    "%s-%s-%s",
    var.project,
    var.role_name == "policyname" ? var.policy : var.role_name,
    var.environment
  )
  policy_name = format(
    "%s-%s-%s",
    var.project,
    var.role_name == "policyname" ? var.policy : var.role_name,
    var.environment
  )
  ddb_table_arn = format(
    "arn:aws:dynamodb:%s:%s:table/%sVulnerableDomains%s",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    replace(title(replace(var.project, "-", " ")), " ", ""),
    title(var.environment),
  )
  ddb_ip_table_arn = format(
    "arn:aws:dynamodb:%s:%s:table/%sIPs%s",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    replace(title(replace(var.project, "-", " ")), " ", ""),
    title(var.environment),
  )
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "lambda" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_role_policy_attachment" "takeover" {
  for_each   = var.takeover ? toset([for policy in data.aws_iam_policy.takeover : policy.arn]) : toset([])
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "lambda" {
  name   = local.policy_name
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}
