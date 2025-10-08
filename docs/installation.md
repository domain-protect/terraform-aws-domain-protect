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

## Domain Protect audit role in every AWS account

By default, Domain Protect uses a CloudFormation Stack Set to deploy an audit role to every AWS account in the Organization, with the exception of the Org Management account.

## Optional self-installation of Domain Protect audit role

Alternatively you can implement the Domain Protect role in every AWS account by another method. Using your tool of choice, create a role called `domain-protect-audit` in every account, with a trust policy as shown in the [example role](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit-trust.json).

Create the audit policy using [this template](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit.json) and attach to the role.

This feature can be disabled by setting the variable:
```
deploy_audit_role = false
```
By default, Domain Protect assumes a role name `domain-protect-audit`. If the role name in your Organization is different, change the value of the variable `security_audit_role_name`.

If you wish to require an external ID as a protection against confused deputy attacks, set the value of the `external_id` variable.

If a role is not present in an account, or there are insufficient permissions attached to the role, Domain Protect will continue to operate with reduced visibility, providing warnings within the CloudWatch log group for the `domain-protect-scan` or `domain-protect-scan-ips` Lambda function


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
