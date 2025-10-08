# Requirements

In order to deploy Domain Protect successfully, it is necessary to meet prerequisites:

* Security tooling account within AWS Organizations
* CloudFormation Stack Set delegated administrator assigned to security tooling account
* Storage bucket for Terraform state file
* OIDC role with [deploy policy](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-deploy.json) assigned, for CI/CD deployment
* Slack App with OAuth token, see [Slack](slack.md) for details
* After initial deployment of Domain Protect, copy the Slack App OAuth token value to the Slack OAuth AWS Secret

## Optional Domain Protect audit role in AWS org management account

If you have Route53 domains or hosted zones in the Organization Management account:

* Create an IAM role n the Org Management account
* Name new role `domain-protect-audit`
* Assign [domain-protect-audit](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit.json) IAM policy
* Set [trust policy](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit-trust-external-id.json) with Security Audit AWS Account ID

* Deploy across  Organization using [CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)
* See [Org Management Account](org-management.md) for more information.

## Requirements for takeover

* Creation of takeover resources in security account must not be blocked in some regions by SCP
* S3 Block Public Access must not be turned on at the account level in the security account
* Production workspace must be named `prd` or set to an alternate using a Terraform variable
* See [automated takeover](automated-takeover.md) for further details

## Organisations with over 1,000 AWS accounts

* A separate scanning Lambda function is started for every AWS account in the organisation
* If you have over 1,000 AWS accounts, request an increase to the Lambda default concurrent execution limit
