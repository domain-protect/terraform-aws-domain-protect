# OWASP Domain Protect

[![Version](https://img.shields.io/github/v/release/domain-protect/terraform-aws-domain-protect)](https://github.com/domain-protect/terraform-aws-domain-protect/releases)
[![Python 3.x](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
![OWASP Maturity](https://img.shields.io/badge/owasp-incubator%20project-53AAE5.svg)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/domain-protect/terraform-aws-domain-protect/badge)](https://scorecard.dev/viewer/?uri=github.com/domain-protect/terraform-aws-domain-protect)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/9420/badge)](https://www.bestpractices.dev/projects/9420)

An open-source public [Terraform registry module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest) to deploy serverless infrastructure that continuously monitors DNS to detect vulnerable and misconfigured domains, and prevents subdomain takeover:

* scan Amazon Route53 across an AWS Organization for domain records vulnerable to takeover
* scan [Cloudflare](docs/cloudflare.md) for vulnerable DNS records
* identify [misconfigured DNS](docs/misconfigured-dns.md) issues
* take over vulnerable subdomains yourself before attackers and bug bounty researchers
* automatically create known issues in [Bugcrowd](docs/bugcrowd.md) or [HackerOne](docs/hackerone.md)
* vulnerable domains in Google Cloud DNS can be detected by [Domain Protect for GCP](https://github.com/ovotech/domain-protect-gcp)
* [manual scans](manual_scans/aws/README.md) of cloud accounts with no installation

## Prevent subdomain takeover ...
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/slack-webhook-notifications.png" /></a>

## ... with serverless cloud infrastructure
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/domain-protect.png" /></a>

## OWASP Global AppSec Dublin - talk and demo
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/global-appsec-dublin.png" /></a>
Talk and demo on [YouTube](https://youtu.be/fLrRLmKZTvE)



## Installation
* Domain Protect is packaged as a [public Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)
* Ensure [requirements](docs/requirements.md) are met
* See [Installation](docs/installation.md) for details on how to install

Here is a basic example with slack integration

```hcl
module "domain_protect" {
  source  = "domain-protect/domain-protect/aws"
  # It is recommended to pin every module to a specific version
  # version = "x.x.x"

  ip_address               = true
  org_primary_account      = "123456789012"
  environment              = "prd"
  security_audit_role_name = "domain-protect-audit"
  takeover                 = false
  slack_channels           = ["security-alerts"]
  slack_webhook_urls       = ["https://hooks.slack.com/services/XXXXXXX/YYYYYYYYYYY"]
}
```

## Migration

See [migration](docs/migration.md) for a guide to migrating from the [original Domain Protect repository](https://github.com/domain-protect/domain-protect) to the [Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Collaboration
> 📢 We welcome contributions! Please see the [OWASP Domain Protect website](https://owasp.org/www-project-domain-protect/) for more details.

## Documentation
> 📄 Detailed documentation is on our [Docs](https://domainprotect.cloud) site

## Limitations
This tool cannot guarantee 100% protection against subdomain takeovers.
