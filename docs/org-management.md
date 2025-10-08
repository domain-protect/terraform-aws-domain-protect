# Organization Management Acccount

Be default, Domain Protect assumes it's being installed in a dedicated security tooling account. Domain Protect uses a CloudFormation Stack Set to deploy a security audit role in all AWS accounts in the Organization, with the exception of the Org Management Account.

AWS best practice is to have as few resources as possible within the Organization Management account, and to have the minimum possible users and roles with access to it.

## Option to deploy Domain Protect audit role in Org Management account

The [Domain Protect audit role](https://github.com/domain-protect/terraform-aws-domain-protect/blob/main/aws-iam-policies/domain-protect-audit.json) can be implemented in the Org Management account, which may be appropriate in any of these scenarios:

* Route 53 domains or hosted zones present in Org Management account
* There are resources with public IP addresses in the Org Management account
* There is a preference not to delegate Organization services to other accounts

Domain Protect begins its operations by listing all accounts in the Organization. It will attempt to do this in the security tooling account, which requires an Organization service, e.g. CloudForamtion Stack Sets, to be registerd as a dedicated administrator.

If listing accounts in the Organization is not supported in the security tooling account, Domain Protect will assume the audit role in the Org Management account, and then list all accounts.

Domain Protect will later assume the audit role in the Org Management account again to scan for domains vulnerable to takeover.

Domain Protect does not include Terraform to deploy the optional audit role to the Management account, so if required, this needs to be done separately.
