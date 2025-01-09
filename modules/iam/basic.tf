data "aws_iam_policy_document" "basic" {
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
}
