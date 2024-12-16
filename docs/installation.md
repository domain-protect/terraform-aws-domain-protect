# Installation

Before starting ensure [requirements](requirements.md) are met

## Initial installation

* Include a code snippet in your code based on the example below:

```
module "domain_protect" {
  source  = "domain-protect/domain-protect/aws"
  version = "1.0.0"

  environment              = "dev"
  org_primary_account      = "123456789012"
  slack_channels           = ["security-alerts-dev"]
  slack_webhook_urls       = ["https://hooks.slack.com/services/XXX/XXX/XXX"]
}
```
* Replace the version with the latest in the [Terraform registry](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)
* Add extra variables if desired as detailed in [module inputs](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest?tab=inputs)
* The Slack webhook URL is sensitive and should be protected, e.g. as a CI/CD pipeline secret

## Examples

* see the [examples directory](https://github.com/domain-protect/terraform-aws-domain-protect/tree/main/examples) for complete Terraform examples including `provider.tf` and `backend.tf` files

## Multiple environments
Domain Protect is designed so that multiple environments can be deployed, e.g. `dev` and `prd`.

It's important that only one environment, e.g. `prd` can perform active takeover, to avoid conflicts between environments.

* ensure you only set the variable `takeover = true` for a single environment, e.g. `prd`

Make sure to also update `production_environment` to match the `environment` variable when deploying to production.

## Terraform workspaces

By default Domain Protect uses the value of the Terraform workspace, e.g. `dev` `prd` as the environment name

If you're using external tooling or systems where `terraform.workspace` works differently, you can override the value by setting the `environment` variable.

```hcl
# terraform.tfvars
environment="prod" # used instead of terraform.workspace
```

## Adding notifications to extra Slack channels

* add an extra channel to your slack_channels variable list
* add an extra webhook URL or repeat the same webhook URL to your `slack_webhook_urls` variable list
* apply Terraform
