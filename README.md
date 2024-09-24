# OWASP Domain Protect
<!--
[![Version](https://img.shields.io/github/v/release/domain-protect/terraform-aws-domain-protect)](https://github.com/domain-protect/terraform-aws-domain-protect/releases/tag/0.1.0)
-->

[![Python 3.x](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
![OWASP Maturity](https://img.shields.io/badge/owasp-incubator%20project-53AAE5.svg)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/domain-protect/terraform-aws-domain-protect/badge)](https://scorecard.dev/viewer/?uri=github.com/domain-protect/terraform-aws-domain-protect)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/9420/badge)](https://www.bestpractices.dev/projects/9420)

Published as a public [Terraform registry module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Prevent subdomain takeover ...
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/images/slack-webhook-notifications.png" /></a>

## ... with serverless cloud infrastructure
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/images/domain-protect.png" /></a>

## OWASP Global AppSec Dublin - talk and demo
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/images/global-appsec-dublin.png" /></a>
Talk and demo on [YouTube](https://youtu.be/fLrRLmKZTvE)

## Features
* scan Amazon Route53 across an AWS Organization for domain records vulnerable to takeover
* scan [Cloudflare](docs/cloudflare.md) for vulnerable DNS records
* take over vulnerable subdomains yourself before attackers and bug bounty researchers
* automatically create known issues in [Bugcrowd](docs/bugcrowd.md) or [HackerOne](docs/hackerone.md)
* vulnerable domains in Google Cloud DNS can be detected by [Domain Protect for GCP](https://github.com/ovotech/domain-protect-gcp)
* [manual scans](manual_scans/aws/README.md) of cloud accounts with no installation

## Installation
* the simplest way to install is to use the separate [Domain Protect Deploy](https://github.com/domain-protect/domain-protect-deploy) repository with GitHub Actions deployment workflow
* for other methods see [Installation](docs/installation.md)

## Collaboration
We welcome collaborators! Please see the [OWASP Domain Protect website](https://owasp.org/www-project-domain-protect/) for more details.

## Documentation
[Manual scans - AWS](manual_scans/aws/README.md)<br>
[Manual scans - CloudFlare](manual_scans/cloudflare/README.md)<br>
[Architecture](docs/architecture.md)<br>
[Database](docs/database.md)<br>
[Reports](docs/reports.md)<br>
[Automated takeover](docs/automated-takeover.md) *optional feature*<br>
[Cloudflare](docs/cloudflare.md) *optional feature*<br>
[Bugcrowd](docs/bugcrowd.md) *optional feature*<br>
[HackerOne](docs/hackerone.md) *optional feature*<br>
[Vulnerability types](docs/vulnerability-types.md)<br>
[Vulnerable A records (IP addresses)](docs/a-records.md) *optional feature*<br>
[Requirements](docs/requirements.md)<br>
[Installation](docs/installation.md)<br>
[Slack Webhooks](docs/slack-webhook.md)<br>
[AWS IAM policies](docs/aws-iam-policies.md)<br>
[CI/CD](docs/ci-cd.md)<br>
[Development](docs/development.md)<br>
[Code Standards](docs/code-standards.md)<br>
[Automated Tests](docs/automated-tests.md)<br>
[Manual Tests](docs/manual-tests.md)<br>
[Conference Talks and Blog Posts](docs/talks.md)<br>

## Limitations
This tool cannot guarantee 100% protection against subdomain takeovers.
