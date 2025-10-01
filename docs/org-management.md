# Organization Management Acccount

There are two options for setting up Domain Protect with the Org Management account:

## No new resources in Org Management account (Standard approach)

AWS best practice is to have as few resources as possible within the Organization Management account, and to have the minimum possible users and roles with access to it.

In line with this, the recommended approach for Domain Protect installation is:

* install Domain Protect in a dedicated security tooling AWS account
* don't create the [Domain Protect audit role](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit.json) in the Org Management account
* delegate an Organization service, e.g. Cloud Formation Stack Sets, to the security tooling account
* this allows Domain Protect to list all AWS accounts in the organisation, essential for correct operation of Domain Protect

## Domain Protect audit role in Org Management account (Alternative approach)

The [Domain Protect audit role](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit.json) can be implemented in the Org Management account, which may be appropriate in either of these scenarios:

* Route 53 domains or hosted zones present in Org Management account
* There is a preference not to delegate Organization services to other accounts

If present, Domain Protect will assume the role in the Org Management account, and use this role both to list all accounts, and to test for domains vulnerable to takeover.
