module "domain_protect" {
  source = "../../"

  scan_schedule    = "60 minutes"
  update_schedule  = "3 hours"
  ip_scan_schedule = "24 hours"

  takeover = true
}

resource "aws_iam_role" "domain_protect_org_role" {
  provider = aws.org

  assume_role_policy = "UPDATE FROM DOCS"
}
