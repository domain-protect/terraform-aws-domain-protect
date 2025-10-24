module "domain_protect" {
  source = "../../"
  # source  = "domain-protect/domain-protect/aws"
  # version = "1.0.0"

  allowed_regions     = ["eu-west-1", "eu-west-2", "us-east-1"]
  aws_ip_addresses    = ["96.0.36.220", "18.96.8.1"]
  cloudflare          = true
  cloudflare_api_key  = var.cloudflare_api_key
  cloudflare_email    = var.cloudflare_email
  environment         = "dev"
  hackerone           = "disabled"
  ip_time_limit       = 0.1 # 6 minutes
  org_primary_account = var.org_primary_account
  rcu                 = 1
  slack_channels      = ["devsecops-dev"]
  takeover            = false
  wcu                 = 1
}
