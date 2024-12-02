# Migration

Domain Protect was initially published as a [stand-alone Terraform repository](https://domain-protect/domain-protect) which is no longer being maintained.

Domain Protect has now been published as a [public Terraform module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest) from the repo [terraform-aws-domain-protect](https://github.com/domain-protect-terraform-aws-domain-protect).

Users of Domain Protect should migrate to use the Terraform module which has the benefits of increased flexibility and straightforward updates.

Steps to migrate from the stand-alone repository to the module are detailed below.

## Migration Option 1 - Destroy and recreate

This is the simplest option, however you will lose your vulnerability and IP address databases. There's also likely to be some downtime during the switchover.

* Destroy the old evironment using `terraform destroy`
* Create a new environment using the [Terraform module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Migration Option 2 - Phased upgrade

Phased option preserving databases and avoiding downtime:

* Upgrade Domain Protect using your existing deployment methodology from the [original Domain Protect repository](https://github.com/domain-protect/domain-protect) to version `0.5.1` and your current variables
* This is pinned to use version `0.5.1` of the Terraform module
* Create a new repository for your deployment(s), calling the Terraform module directly, which should result in no changes other than the usual Lambda rebuild
* See the [examples folder](https://github.com/domain-protect/terraform-aws-domain-protect/tree/main/examples) in this repository for example Terraform
* Update the Terraform module version to the latest version, this will require some adjustment of Terraform variables:

    * `slack_channels_dev` no longer used - simply pass in different variables for each environment
    * set `takeover` as `true` in prod and `false` in development environment

* Ensure no changes with a Terraform plan for each environment, other than the usual Lambda rebuilds
* After you've finished, destroy or archive your old repository
