data "aws_caller_identity" "current" {}

data "aws_iam_policy" "default" {
  for_each = toset([
    "AdministratorAccess-AWSElasticBeanstalk",
    "AWSCloudFormationFullAccess",
    "AmazonS3FullAccess",
    "AmazonVPCFullAccess", 
  ])
  name = each.value
}
