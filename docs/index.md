# OWASP Domain Protect

[![Version](https://img.shields.io/github/v/release/domain-protect/terraform-aws-domain-protect)](https://github.com/domain-protect/terraform-aws-domain-protect/releases/tag/0.5.0)
[![Python 3.x](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
![OWASP Maturity](https://img.shields.io/badge/owasp-incubator%20project-53AAE5.svg)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/domain-protect/terraform-aws-domain-protect/badge)](https://scorecard.dev/viewer/?uri=github.com/domain-protect/terraform-aws-domain-protect)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/9420/badge)](https://www.bestpractices.dev/projects/9420)

Published as a public [Terraform registry module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)


Prevent subdomain takeover ...

![Alt text](assets/images/slack-webhook-notifications.png?raw=true "Domain Protect architecture")

 ... with serverless cloud infrastructure

![Alt text](assets/images/domain-protect.png?raw=true "Domain Protect architecture")

## OWASP Global AppSec Dublin - talk and demo
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/global-appsec-dublin.png" /></a>
Talk and demo on [YouTube](https://youtu.be/fLrRLmKZTvE)

## Features
* scan Amazon Route53 across an AWS Organization for domain records vulnerable to takeover
* scan [Cloudflare](cloudflare.md) for vulnerable DNS records
* take over vulnerable subdomains yourself before attackers and bug bounty researchers
* automatically create known issues in [Bugcrowd](bugcrowd.md) or [HackerOne](hackerone.md)
* vulnerable domains in Google Cloud DNS can be detected by [Domain Protect for GCP](https://github.com/ovotech/domain-protect-gcp)
* [manual scans](manual-aws-scans.md) of cloud accounts with no installation

## Installation
* Domain Protect is packaged as a [public Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)
* Ensure [requirements](requirements.md) are met
* See [Installation](installation.md) for details on how to install

## Migration

See [migration](migration.md) for a guide to migrating from the [original Domain Protect repository](https://github.com/domain-protect/domain-protect) to the [Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Collaboration
We welcome collaborators! Please see the [OWASP Domain Protect website](https://owasp.org/www-project-domain-protect/) for more details.

## Documentation
[Manual scans - AWS](manual-aws-scans.md)<br>
[Manual scans - CloudFlare](manual-cf-scans.md)<br>
[Architecture](architecture.md)<br>
[Database](database.md)<br>
[Reports](reports.md)<br>
[Automated takeover](automated-takeover.md) *optional feature*<br>
[Cloudflare](cloudflare.md) *optional feature*<br>
[Bugcrowd](bugcrowd.md) *optional feature*<br>
[HackerOne](hackerone.md) *optional feature*<br>
[Vulnerability types](vulnerability-types.md)<br>
[Vulnerable A records (IP addresses)](a-records.md) *optional feature*<br>
[Requirements](requirements.md)<br>
[Installation](installation.md)<br>
[Migration](migration.md)<br>
[Slack Webhooks](slack-webhook.md)<br>
[AWS IAM policies](aws-iam-policies.md)<br>
[CI/CD](ci-cd.md)<br>
[Development](development.md)<br>
[Code Standards](code-standards.md)<br>
[Automated Tests](automated-tests.md)<br>
[Manual Tests](manual-tests.md)<br>
[Conference Talks and Blog Posts](talks.md)<br>

## Limitations
This tool cannot guarantee 100% protection against subdomain takeovers.
