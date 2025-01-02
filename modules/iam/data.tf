data "aws_caller_identity" "current" {}

data "aws_iam_policy" "default" {
  for_each = var.takeover ? toset([
    "AdministratorAccess-AWSElasticBeanstalk",
    "AWSCloudFormationFullAccess",
    "AmazonS3FullAccess",
    "AmazonVPCFullAccess", 
  ]) : toset([])
  name = each.value
}
