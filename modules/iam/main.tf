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
  ddb_table_name = format("%sVulnerableDomains%s",
    replace(title(replace(var.project, "-", " ")), " ", ""),
    title(var.environment),
  )
  ddb_ip_table_name = format("%sIPs%s",
    replace(title(replace(var.project, "-", " ")), " ", ""),
    title(var.environment),
  )
  dynamodb_arns = compact([
    data.aws_dynamodb_table.vulnerable_domains.arn,
    one(data.aws_dynamodb_table.ips[*].arn),
  ])
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_dynamodb_table" "vulnerable_domains" {
  name = local.ddb_table_name
}

data "aws_dynamodb_table" "ips" {
  count = var.ip_address ? 1 : 0
  name  = local.ddb_ip_table_name
}

resource "aws_iam_role" "lambda" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_role_policy_attachment" "takeover" {
  for_each   = var.takeover ? toset([for policy in data.aws_iam_policy_document.takeover : policy.arn]) : toset([])
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "lambda" {
  name   = local.policy_name
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}
