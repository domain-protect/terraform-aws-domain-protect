data "aws_iam_policy_document" "takeover" {
  count = var.takeover ? 1 : 0
  statement {
    sid       = "WriteToCloudWatchLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "PutCloudWatchMetrics"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:PutMetricData"]
  }

  statement {
    sid    = "SNS"
    effect = "Allow"

    resources = [
      "arn:aws:sns:*:*:${var.project}-${var.environment}",
      "arn:aws:sns:*:*:${var.project}-dlq-${var.environment}",
    ]

    actions = [
      "sns:Publish",
      "sns:Subscribe",
    ]
  }

  statement {
    sid       = "KMSforSNS"
    effect    = "Allow"
    resources = [var.kms_arn]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
  }

  statement {
    sid       = "GetAccountName"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:ListAccountAliases"]
  }

  statement {
    sid    = "IAMPermissionsForElasticBEanstalk"
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/${var.project}*",
      "arn:aws:iam::*:instance-profile/${var.project}*",
    ]

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteInstanceProfile",
      "iam:DeleteRole",
      "iam:DetachRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:PassRole",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:TagRole",
      "iam:UntagInstanceProfile",
      "iam:UntagRole",
      "iam:UpdateRole",
    ]
  }
}
