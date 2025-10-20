# Domain Protect Audit Role

By default, Domain Protect uses a CloudFormation Stack Set to deploy the Domain Protecty audit role to every AWS account in the Organization, with the exception of the Org Management account.

If you have Route53 zones or domains in the Org Management account you'll need to separately install the Domain Protect audit role to that account, as described in [Org Management Account](org-management.md).

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
