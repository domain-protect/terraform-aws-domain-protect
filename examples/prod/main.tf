module "domain_protect" {
  source = "../../"

  scan_schedule    = "60 minutes"
  update_schedule  = "3 hours"
  ip_scan_schedule = "24 hours"

  takeover = true
}
