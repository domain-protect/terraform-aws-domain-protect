data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "takeover" {
  for_each = var.takeover ? toset(var.managed_policy_names) : toset([])
  name     = each.value
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["${var.assume_role_policy}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda" {
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
    sid       = "AssumeSecurityAuditRole"
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/${var.security_audit_role_name}"]
    actions   = ["sts:AssumeRole"]
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
    resources = ["${var.kms_arn}"]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
  }

  statement {
    sid    = "DynamoDB"
    effect = "Allow"

    resources = [
      "${local.ddb_table_arn}",
      "${local.ddb_ip_table_arn}",
    ]

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
  }
}


data "aws_iam_policy_document" "takeover" {
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
    resources = ["${var.kms_arn}"]

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

data "aws_iam_policy_document" "resources" {
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
    resources = ["${var.kms_arn}"]

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
    sid       = "DescribeRegions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DescribeRegions"]
  }

  statement {
    sid       = "CloudFormation"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudformation:DescribeStacks",
      "cloudformation:ListStacks",
    ]
  }
}

data "aws_iam_policy_document" "accounts" {
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
    sid       = "AssumeSecurityAuditRole"
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/${var.security_audit_role_name}"]
    actions   = ["sts:AssumeRole"]
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
    resources = ["${var.kms_arn}"]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
  }

  statement {
    sid       = "DynamoDB"
    effect    = "Allow"
    resources = ["${local.ddb_table_arn}"]

    actions = [
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
  }

  statement {
    sid       = "StartStateMachine"
    effect    = "Allow"
    resources = ["${var.state_machine_arn}"]
    actions   = ["states:StartExecution"]
  }
}

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
    resources = ["${var.kms_arn}"]

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

data "aws_iam_policy_document" "states" {
  statement {
    sid       = "CloudWatchLogs"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]
  }

  statement {
    sid       = "XRay"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
    ]
  }

  statement {
    sid       = "PutCloudWatchMetrics"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:PutMetricData"]
  }

  statement {
    sid       = "Lambda"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:${var.project}-*-${var.environment}"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "KMSforSNS"
    effect    = "Allow"
    resources = ["${var.kms_arn}"]

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
  }
}
