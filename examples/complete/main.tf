module "domain_protect" {
  #source = "../../"
  source  = "domain-protect/domain-protect/aws"
  version = "0.5.1"

  allowed_regions     = "['eu-west-1', 'eu-west-2', 'us-east-1']"
  cf_api_key          = var.cf_api_key
  cloudflare          = true
  external_id         = var.external_id
  hackerone           = "enabled"
  ip_address          = true
  ip_scan_schedule    = "10 minutes"
  ip_time_limit       = "0.1" #6 minutes
  org_primary_account = var.org_primary_account
  rcu                 = 1
  slack_channels      = terraform.workspace == "prd" ? ["devsecops"] : ["devsecops-dev"]
  scan_schedule       = "10 minutes"
  slack_webhook_type  = "app"
  slack_webhook_urls  = var.slack_webhook_urls
  takeover            = terraform.workspace == "prd" ? true : false
  update_schedule     = "10 minutes"
  wcu                 = 1


}
