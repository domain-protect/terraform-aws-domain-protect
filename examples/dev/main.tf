module "domain_protect" {
  source = "../../"
  # source  = "domain-protect/domain-protect/aws"
  # version = "0.5.1"

  allowed_regions     = "['eu-west-1', 'eu-west-2', 'us-east-1']"
  cf_api_key          = var.cf_api_key
  cloudflare          = true
  environment         = "dev"
  external_id         = var.external_id
  hackerone           = "enabled"
  ip_address          = true
  ip_time_limit       = 0.1 # 6 minutes
  org_primary_account = var.org_primary_account
  rcu                 = 1
  slack_channels      = ["devsecops-dev"]
  slack_webhook_type  = "app"
  slack_webhook_urls  = var.slack_webhook_urls
  takeover            = false
  wcu                 = 1
}
