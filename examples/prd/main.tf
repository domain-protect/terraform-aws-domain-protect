module "domain_protect" {
  source = "../../"
  # source  = "domain-protect/domain-protect/aws"
  # version = "1.0.0"

  allowed_regions     = "['eu-west-1', 'eu-west-2', 'us-east-1']"
  cloudflare          = true
  cloudflare_api_key  = var.cloudflare_api_key
  cloudflare_email    = var.cloudflare_email
  environment         = "prd"
  hackerone           = "disabled"
  ip_scan_schedule    = "10 minutes"
  ip_time_limit       = 0.1 # 6 minutes
  org_primary_account = var.org_primary_account
  rcu                 = 1
  scan_schedule       = "10 minutes"
  slack_channels      = ["devsecops"]
  takeover            = true
  update_schedule     = "10 minutes"
  wcu                 = 1
}
