# OWASP Domain Protect

[![Version](https://img.shields.io/github/v/release/domain-protect/terraform-aws-domain-protect)](https://github.com/domain-protect/terraform-aws-domain-protect/releases)
[![Python 3.x](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
![OWASP Maturity](https://img.shields.io/badge/owasp-incubator%20project-53AAE5.svg)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/domain-protect/terraform-aws-domain-protect/badge)](https://scorecard.dev/viewer/?uri=github.com/domain-protect/terraform-aws-domain-protect)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/9420/badge)](https://www.bestpractices.dev/projects/9420)

Published as a public [Terraform registry module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Prevent subdomain takeover ...
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/slack-webhook-notifications.png" /></a>

## ... with serverless cloud infrastructure
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/domain-protect.png" /></a>

## OWASP Global AppSec Dublin - talk and demo
<a href="#"><img src="https://raw.githubusercontent.com/domain-protect/terraform-aws-domain-protect/main/docs/assets/images/global-appsec-dublin.png" /></a>
Talk and demo on [YouTube](https://youtu.be/fLrRLmKZTvE)

## Features
* scan Amazon Route53 across an AWS Organization for domain records vulnerable to takeover
* scan [Cloudflare](docs/cloudflare.md) for vulnerable DNS records
* take over vulnerable subdomains yourself before attackers and bug bounty researchers
* automatically create known issues in [Bugcrowd](docs/bugcrowd.md) or [HackerOne](docs/hackerone.md)
* vulnerable domains in Google Cloud DNS can be detected by [Domain Protect for GCP](https://github.com/ovotech/domain-protect-gcp)
* [manual scans](manual_scans/aws/README.md) of cloud accounts with no installation

## Installation
* Domain Protect is packaged as a [public Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)
* Ensure [requirements](docs/requirements.md) are met
* See [Installation](docs/installation.md) for details on how to install

## Migration

See [migration](docs/migration.md) for a guide to migrating from the [original Domain Protect repository](https://github.com/domain-protect/domain-protect) to the [Terraform Module](https://registry.terraform.io/modules/domain-protect/domain-protect/aws/latest)

## Collaboration
> 📢 We welcome contributions! Please see the [OWASP Domain Protect website](https://owasp.org/www-project-domain-protect/) for more details.

## Documentation
> 📄 Detailed documentation is on our [Docs](https://domainprotect.cloud) site

## Limitations
This tool cannot guarantee 100% protection against subdomain takeovers.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | > 2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 5.12.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | > 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | > 3.1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_accounts_event"></a> [accounts\_event](#module\_accounts\_event) | ./modules/cloudwatch | n/a |
| <a name="module_accounts_event_ips"></a> [accounts\_event\_ips](#module\_accounts\_event\_ips) | ./modules/cloudwatch | n/a |
| <a name="module_accounts_role"></a> [accounts\_role](#module\_accounts\_role) | ./modules/iam | n/a |
| <a name="module_accounts_role_ips"></a> [accounts\_role\_ips](#module\_accounts\_role\_ips) | ./modules/iam | n/a |
| <a name="module_cloudflare_event"></a> [cloudflare\_event](#module\_cloudflare\_event) | ./modules/cloudwatch | n/a |
| <a name="module_cloudwatch_event"></a> [cloudwatch\_event](#module\_cloudwatch\_event) | ./modules/cloudwatch | n/a |
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ./modules/dynamodb | n/a |
| <a name="module_dynamodb_ips"></a> [dynamodb\_ips](#module\_dynamodb\_ips) | ./modules/dynamodb-ips | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/kms | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/lambda | n/a |
| <a name="module_lambda_accounts"></a> [lambda\_accounts](#module\_lambda\_accounts) | ./modules/lambda-accounts | n/a |
| <a name="module_lambda_accounts_ips"></a> [lambda\_accounts\_ips](#module\_lambda\_accounts\_ips) | ./modules/lambda-accounts | n/a |
| <a name="module_lambda_cloudflare"></a> [lambda\_cloudflare](#module\_lambda\_cloudflare) | ./modules/lambda-cloudflare | n/a |
| <a name="module_lambda_resources"></a> [lambda\_resources](#module\_lambda\_resources) | ./modules/lambda-resources | n/a |
| <a name="module_lambda_role"></a> [lambda\_role](#module\_lambda\_role) | ./modules/iam | n/a |
| <a name="module_lambda_role_ips"></a> [lambda\_role\_ips](#module\_lambda\_role\_ips) | ./modules/iam | n/a |
| <a name="module_lambda_scan"></a> [lambda\_scan](#module\_lambda\_scan) | ./modules/lambda-scan | n/a |
| <a name="module_lambda_scan_ips"></a> [lambda\_scan\_ips](#module\_lambda\_scan\_ips) | ./modules/lambda-scan-ips | n/a |
| <a name="module_lambda_slack"></a> [lambda\_slack](#module\_lambda\_slack) | ./modules/lambda-slack | n/a |
| <a name="module_lambda_takeover"></a> [lambda\_takeover](#module\_lambda\_takeover) | ./modules/lambda-takeover | n/a |
| <a name="module_lamdba_stats"></a> [lamdba\_stats](#module\_lamdba\_stats) | ./modules/lambda-stats | n/a |
| <a name="module_resources_event"></a> [resources\_event](#module\_resources\_event) | ./modules/cloudwatch | n/a |
| <a name="module_resources_role"></a> [resources\_role](#module\_resources\_role) | ./modules/iam | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ./modules/sns | n/a |
| <a name="module_sns_dead_letter_queue"></a> [sns\_dead\_letter\_queue](#module\_sns\_dead\_letter\_queue) | ./modules/sns | n/a |
| <a name="module_step_function"></a> [step\_function](#module\_step\_function) | ./modules/step-function | n/a |
| <a name="module_step_function_ips"></a> [step\_function\_ips](#module\_step\_function\_ips) | ./modules/step-function | n/a |
| <a name="module_step_function_role"></a> [step\_function\_role](#module\_step\_function\_role) | ./modules/iam | n/a |
| <a name="module_takeover_role"></a> [takeover\_role](#module\_takeover\_role) | ./modules/iam | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_regions"></a> [allowed\_regions](#input\_allowed\_regions) | If SCPs block certain regions across all accounts, optionally replace with string formatted list of allowed regions | `string` | `"['all']"` | no |
| <a name="input_bugcrowd"></a> [bugcrowd](#input\_bugcrowd) | Set to enabled for Bugcrowd integration | `string` | `"disabled"` | no |
| <a name="input_bugcrowd_api_key"></a> [bugcrowd\_api\_key](#input\_bugcrowd\_api\_key) | Bugcrowd API token | `string` | `""` | no |
| <a name="input_bugcrowd_email"></a> [bugcrowd\_email](#input\_bugcrowd\_email) | Email address of Bugcrowd researcher service account | `string` | `""` | no |
| <a name="input_bugcrowd_state"></a> [bugcrowd\_state](#input\_bugcrowd\_state) | State in which issue is created, e.g. new, triaged, unresolved, resolved | `string` | `"unresolved"` | no |
| <a name="input_cf_api_key"></a> [cf\_api\_key](#input\_cf\_api\_key) | Cloudflare API token | `string` | `""` | no |
| <a name="input_cloudflare"></a> [cloudflare](#input\_cloudflare) | Set to true to enable CloudFlare | `bool` | `false` | no |
| <a name="input_cloudflare_lambdas"></a> [cloudflare\_lambdas](#input\_cloudflare\_lambdas) | list of names of Lambda files in the lambda-cloudflare/code folder | `list(any)` | <pre>[<br/>  "cloudflare-scan"<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment deploying to, defaults to terraform.workspace - optionally enter in tfvars file | `string` | `""` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | external ID for security audit role to be defined in tvars file. Leave empty if not configured | `string` | `""` | no |
| <a name="input_hackerone"></a> [hackerone](#input\_hackerone) | Set to enabled for HackerOne integration | `string` | `"disabled"` | no |
| <a name="input_hackerone_api_token"></a> [hackerone\_api\_token](#input\_hackerone\_api\_token) | HackerOne API token | `string` | `""` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | Set to true to enable A record checks using IP address scans | `bool` | `false` | no |
| <a name="input_ip_scan_schedule"></a> [ip\_scan\_schedule](#input\_ip\_scan\_schedule) | schedule for IP address scanning used in A record checks | `string` | `"24 hours"` | no |
| <a name="input_ip_time_limit"></a> [ip\_time\_limit](#input\_ip\_time\_limit) | maximum time in hours since IP last detected, before considering IP as no longer belonging to organisation | `string` | `"48"` | no |
| <a name="input_lambdas"></a> [lambdas](#input\_lambdas) | list of names of Lambda files in the lambda/code folder | `list(any)` | <pre>[<br/>  "current",<br/>  "update"<br/>]</pre> | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory allocation for scanning Lambda functions | `number` | `128` | no |
| <a name="input_memory_size_slack"></a> [memory\_size\_slack](#input\_memory\_size\_slack) | Memory allocation for Slack Lambda functions | `number` | `128` | no |
| <a name="input_org_primary_account"></a> [org\_primary\_account](#input\_org\_primary\_account) | The AWS account number of the organization primary account | `string` | n/a | yes |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | permissions boundary ARN to attach to every IAM role | `string` | `null` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | Python platform used for install of Regex and other libraries | `string` | `"manylinux2014_x86_64"` | no |
| <a name="input_production_environment"></a> [production\_environment](#input\_production\_environment) | Name of production environment - takeover is only turned on in this environment | `string` | `""` | no |
| <a name="input_production_workspace"></a> [production\_workspace](#input\_production\_workspace) | Deprecated, use production\_environment. Will be removed in a future release | `string` | `"prd"` | no |
| <a name="input_project"></a> [project](#input\_project) | abbreviation for the project, forms first part of resource names | `string` | `"domain-protect"` | no |
| <a name="input_rcu"></a> [rcu](#input\_rcu) | DynamoDB Read Capacity Units for vulnerability database | `number` | `3` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy Lambda functions | `string` | `"eu-west-1"` | no |
| <a name="input_reports_schedule"></a> [reports\_schedule](#input\_reports\_schedule) | schedule for running reports, e.g. 24 hours. Irrespective of setting, you will be immediately notified of new vulnerabilities | `string` | `"24 hours"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda language runtime. Defaults to the `python-version` in repo and can be overridden. | `string` | `""` | no |
| <a name="input_scan_schedule"></a> [scan\_schedule](#input\_scan\_schedule) | schedule for running domain-protect scans, e.g. 24 hours | `string` | `"24 hours"` | no |
| <a name="input_security_audit_role_name"></a> [security\_audit\_role\_name](#input\_security\_audit\_role\_name) | security audit role name which needs to be the same in all AWS accounts | `string` | `"domain-protect-audit"` | no |
| <a name="input_slack_channels"></a> [slack\_channels](#input\_slack\_channels) | List of Slack Channels - enter in tfvars file | `list(string)` | `[]` | no |
| <a name="input_slack_emoji"></a> [slack\_emoji](#input\_slack\_emoji) | Slack emoji | `string` | `":warning:"` | no |
| <a name="input_slack_fix_emoji"></a> [slack\_fix\_emoji](#input\_slack\_fix\_emoji) | Slack fix emoji | `string` | `":white_check_mark:"` | no |
| <a name="input_slack_new_emoji"></a> [slack\_new\_emoji](#input\_slack\_new\_emoji) | Slack emoji for new vulnerability | `string` | `":octagonal_sign:"` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | Slack username appearing in the from field in the Slack message | `string` | `"Domain Protect"` | no |
| <a name="input_slack_webhook_type"></a> [slack\_webhook\_type](#input\_slack\_webhook\_type) | Slack webhook type, can be legacy or app | `string` | `"legacy"` | no |
| <a name="input_slack_webhook_urls"></a> [slack\_webhook\_urls](#input\_slack\_webhook\_urls) | List of Slack webhook URLs, in the same order as the slack\_channels list - enter in tfvars file | `list(string)` | `[]` | no |
| <a name="input_stats_schedule"></a> [stats\_schedule](#input\_stats\_schedule) | Cron schedule for the stats message | `string` | `"cron(0 9 1 * ? *)"` | no |
| <a name="input_takeover"></a> [takeover](#input\_takeover) | Create supported resource types to prevent malicious subdomain takeover | `bool` | `false` | no |
| <a name="input_update_lambdas"></a> [update\_lambdas](#input\_update\_lambdas) | list of Cloudflare Lambda functions updating vulnerability status | `list(any)` | <pre>[<br/>  "update"<br/>]</pre> | no |
| <a name="input_update_schedule"></a> [update\_schedule](#input\_update\_schedule) | schedule for running domain-protect update function, e.g. 24 hours | `string` | `"24 hours"` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Provide this to allow your function to access your VPC (if both 'subnet\_ids' and 'security\_group\_ids' are empty then<br/>  vpc\_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). | <pre>object({<br/>    security_group_ids = list(string)<br/>    subnet_ids         = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_wcu"></a> [wcu](#input\_wcu) | DynamoDB Write Capacity Units for vulnerability database | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts_event"></a> [accounts\_event](#output\_accounts\_event) | Outputs of module.accounts\_event |
| <a name="output_accounts_event_ips"></a> [accounts\_event\_ips](#output\_accounts\_event\_ips) | Outputs of module.accounts\_event\_ips |
| <a name="output_accounts_role"></a> [accounts\_role](#output\_accounts\_role) | Outputs of module.accounts\_role |
| <a name="output_accounts_role_ips"></a> [accounts\_role\_ips](#output\_accounts\_role\_ips) | Outputs of module.accounts\_role\_ips |
| <a name="output_cloudflare_event"></a> [cloudflare\_event](#output\_cloudflare\_event) | Outputs of module.cloudflare\_event |
| <a name="output_cloudwatch_event"></a> [cloudwatch\_event](#output\_cloudwatch\_event) | Outputs of module.cloudwatch\_event |
| <a name="output_dynamodb"></a> [dynamodb](#output\_dynamodb) | Outputs of module.dynamodb |
| <a name="output_dynamodb_ips"></a> [dynamodb\_ips](#output\_dynamodb\_ips) | Outputs of module.dynamodb\_ips |
| <a name="output_kms"></a> [kms](#output\_kms) | Outputs of module.kms |
| <a name="output_lambda"></a> [lambda](#output\_lambda) | Outputs of module.lambda |
| <a name="output_lambda_accounts"></a> [lambda\_accounts](#output\_lambda\_accounts) | Outputs of module.lambda\_accounts |
| <a name="output_lambda_accounts_ips"></a> [lambda\_accounts\_ips](#output\_lambda\_accounts\_ips) | Outputs of module.lambda\_accounts\_ips |
| <a name="output_lambda_cloudflare"></a> [lambda\_cloudflare](#output\_lambda\_cloudflare) | Outputs of module.lambda\_cloudflare |
| <a name="output_lambda_resources"></a> [lambda\_resources](#output\_lambda\_resources) | Outputs of module.lambda\_resources |
| <a name="output_lambda_role"></a> [lambda\_role](#output\_lambda\_role) | Outputs of module.lambda\_role |
| <a name="output_lambda_role_ips"></a> [lambda\_role\_ips](#output\_lambda\_role\_ips) | Outputs of module.lambda\_role\_ips |
| <a name="output_lambda_scan"></a> [lambda\_scan](#output\_lambda\_scan) | Outputs of module.lambda\_scan |
| <a name="output_lambda_scan_ips"></a> [lambda\_scan\_ips](#output\_lambda\_scan\_ips) | Outputs of module.lambda\_scan\_ips |
| <a name="output_lambda_slack"></a> [lambda\_slack](#output\_lambda\_slack) | Outputs of module.lambda\_slack |
| <a name="output_lambda_takeover"></a> [lambda\_takeover](#output\_lambda\_takeover) | Outputs of module.lambda\_takeover |
| <a name="output_lamdba_stats"></a> [lamdba\_stats](#output\_lamdba\_stats) | Outputs of module.lamdba\_stats |
| <a name="output_resources_event"></a> [resources\_event](#output\_resources\_event) | Outputs of module.resources\_event |
| <a name="output_resources_role"></a> [resources\_role](#output\_resources\_role) | Outputs of module.resources\_role |
| <a name="output_sns"></a> [sns](#output\_sns) | Outputs of module.sns |
| <a name="output_sns_dead_letter_queue"></a> [sns\_dead\_letter\_queue](#output\_sns\_dead\_letter\_queue) | Outputs of module.sns\_dead\_letter\_queue |
| <a name="output_step_function"></a> [step\_function](#output\_step\_function) | Outputs of module.step\_function |
| <a name="output_step_function_ips"></a> [step\_function\_ips](#output\_step\_function\_ips) | Outputs of module.step\_function\_ips |
| <a name="output_step_function_role"></a> [step\_function\_role](#output\_step\_function\_role) | Outputs of module.step\_function\_role |
| <a name="output_takeover_role"></a> [takeover\_role](#output\_takeover\_role) | Outputs of module.takeover\_role |
<!-- END_TF_DOCS -->
