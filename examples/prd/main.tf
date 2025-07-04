module "domain_protect" {
  source = "../../"
  # source  = "domain-protect/domain-protect/aws"
  # version = "1.0.0"

  allowed_regions     = "['eu-west-1', 'eu-west-2', 'us-east-1']"
  cloudflare          = true
  cloudflare_api_key  = var.cloudflare_api_key
  cloudflare_email    = var.cloudflare_email
  environment         = "prd"
  external_id         = var.external_id
  hackerone           = "disabled"
  ip_address          = true
  ip_scan_schedule    = "10 minutes"
  ip_time_limit       = 0.1 # 6 minutes
  org_primary_account = var.org_primary_account
  rcu                 = 1
  scan_schedule       = "10 minutes"
  slack_channels      = ["devsecops"]
  slack_webhook_type  = "app"
  slack_webhook_urls  = var.slack_webhook_urls
  takeover            = true
  update_schedule     = "10 minutes"
  wcu                 = 1
}
