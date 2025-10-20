# Installation

Before starting ensure [requirements](requirements.md) are met

## Initial installation

* Include a code snippet in your code based on the example below:

```
module "domain_protect" {
  source  = "domain-protect/domain-protect/aws"
  version = "4.0.0"

  environment              = "prd"
  org_primary_account      = "123456789012"
  slack_channels           = ["security-alerts"]
}
```
* Replace the version with the latest in the [Terraform registry](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)
* Add extra variables if desired as detailed in [module inputs](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest?tab=inputs)
* After installation, copy the Slack OAuth app token value to the OAuth Slack AWS Secret

## Examples

* see the [examples directory](https://github.com/domain-protect/terraform-aws-domain-protect/tree/main/examples) for complete Terraform examples including `provider.tf` and `backend.tf` files

## A record (IP address) vulnerabilities

False positive alerts can occur when an 'A' record legitimately points to an IP address in an AWS account outside your organisation,
for example a company website hosted by a third party.

See [A Records](a-records.md)  for actions to prevent false positives, and how to disable A record vulnerability detection.

## Domain Protect audit role in every AWS account

By default, Domain Protect uses a CloudFormation Stack Set to deploy an audit role to every AWS account in the Organization, with the exception of the Org Management account.

Optionally you can self-install the Domain Protect audit role by another method, as detailed in [Domain Protect audit role](audit-role.md).

If you have Route53 zones or domains in the Org Management account you'll need to separately install the Domain Protect audit role to that account, as described in [Org Management Account](org-management.md).

## Multiple environments
Domain Protect is designed so that multiple environments can be deployed within the security tooling account, e.g. `dev` and `prd`, all using the same Domain Protect audit role in every account.

The Domain Protect audit role is deployed to every account in the Organzation by a CloudFormation Stack Set from the security tooling account. This initial deployment must be done from the production environment, e.g. `prd`.

It's important that only one environment, e.g. `prd` can perform active takeover, to avoid conflicts between environments.

* ensure you only set the variable `takeover = true` for a single environment, e.g. `prd`

If you wish to use a different abbreviation for your production environment, change the value of the `production_environment` variable.

## Terraform workspaces

If you wish to use the same Terraform state bucket in the security tooling account for multiple environments, this can be done by Terraform workspaces with names matching the environment names, e.g. `dev` `prd`.

## Adding notifications to extra Slack channels

* add an extra channel to your slack_channels variable list
* apply Terraform
