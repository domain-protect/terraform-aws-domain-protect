module "domain_protect" {
  source = "../../"

  scan_schedule    = var.scan_schedule
  update_schedule  = var.update_schedule
  ip_scan_schedule = var.ip_scan_schedule
  takeover         = var.takeover
}
