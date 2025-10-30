# Misconfigured DNS
*optional feature turned on by default*

![Alt text](assets/images/misconfigured-dns.png?raw=true "Vulnerable A Record")

## Misconfiguration issues detected
Misconfigured DNS delegation of AWS hosted zones:

* non-authoritative hosted zones
* delegation record doesn't include all AWS hosted zones name servers
* one or more incorrect name servers in delegation record

## Schedule
* scan frequency controlled by `reports_schedule` Terraform variable
* default frequency: `24 hours`

## No database
* Misconfigured DNS issues not stored in a database
* Slack alert will stop once issue is resolved
* no "Fixed" messages when resolved
* not included in monthly stats

## How to disable
* Disable misconfigured DNS detection by setting Terraform variable:
```
misconfigured = false
```
