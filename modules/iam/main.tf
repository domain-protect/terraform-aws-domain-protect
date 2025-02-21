resource "aws_iam_role" "lambda" {
  name                 = "${var.project}-${var.takeover ? "takeover" : var.role_name == "policyname" ? var.policy : var.role_name}-${var.environment}"
  assume_role_policy   = templatefile("${path.module}/templates/${var.assume_role_policy}_role.json.tpl", { project = var.project })
  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = var.takeover ? toset([for policy in data.aws_iam_policy.default : policy.arn]) : toset([])
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.project}-${var.role_name == "policyname" ? var.policy : var.role_name}-${var.environment}"
  role = aws_iam_role.lambda.id
  policy = templatefile("${path.module}/templates/${var.policy}_policy.json.tpl", {
    security_audit_role_name = var.security_audit_role_name,
    project                  = var.project,
    env                      = var.environment,
    kms_arn                  = var.kms_arn,
    ddb_table_arn            = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${replace(title(replace(var.project, "-", " ")), " ", "")}VulnerableDomains${title(var.environment)}",
    ddb_ip_table_arn         = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${replace(title(replace(var.project, "-", " ")), " ", "")}IPs${title(var.environment)}",
    state_machine_arn        = var.state_machine_arn,
  })
}
