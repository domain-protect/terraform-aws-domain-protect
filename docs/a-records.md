# Vulnerable A records (IP addresses)
*optional feature turned on by default*

* detects A records pointing to AWS IP addresses no longer in use within organisation
  * Elastic IP addresses
  * EC2 instances with public IP addresses
  * ECS Fargate public IP addresses
  * Global Accelerator IP addresses
* automated takeover not supported

![Alt text](assets/images/a-record-vulnerable.png?raw=true "Vulnerable A Record")

![Alt text](assets/images/a-record-fixed.png?raw=true "Fixed A Record")

## How an A record becomes vulnerable
A records pointing to an IPv4 address can be vulnerable to subdomain takeover:

* engineer creates EC2 instance with public IP address
* engineer creates Route53 A record pointing to address
* engineer deletes EC2 instance, releasing IP address
* engineer forgets to remove Route53 DNS record
* attacker creates EC2 instance in own AWS account, with same IP address
* company DNS record now points to attacker's virtual machine

## How Domain Protect determines if A record is vulnerable
* decision flow designed to minimise false positives
* only detects certain types of A record vulnerabilities

![Alt text](assets/images/a-record-decision-tree.png?raw=true "A Record decision tree")

## Domain Protect IP address database
* DynamoDB database table for IP addresses in Organization
* separate from vulnerability DynamoDB table

![Alt text](assets/images/ip-database.png?raw=true "IP Address database")

## Authorising IP addresses outside AWS Organization
The A record check may create false positive alerts where the IP address is outside the AWS Organization scanned by Domain Protect, for example:

* public IP address in service provider AWS account
* public IP address on-premise
* public IP address in private data centre

There are two methods which can be used to authorise IP addresses outside the AWS Organization:

* authorise networks outside AWS Organization (recommended)
* record IP address as OK in DynamoDB (not recommended)

Each method is detailed below.

## Authorise networks outside AWS Organization (recommended)
Approved networks outside AWS can be pre-authorised by setting the Terraform variable, using CIDR notation:

```
networks = ['212.137.0.0/16', '84.67.112.128/26']
```

This approach ensures exception configuration uses infrastructure-as-code, and doesn't require administrator access to the database.

## Record IP address as OK in DynamoDB (not recommended)
To authorise a single IP address (not a network):

* manually create item in IP address DynamoDB database
* enter IP address known to be authorised
* create Account field with text starting `IP OK`
* item must be manually removed when resource is decommissioned

![Alt text](assets/images/ip-exception.png?raw=true "IP Address exception")

## Disabling A record feature
* set Terraform variable in your CI/CD pipeline or tfvars file:
```
ip_address = false
```
* apply Terraform

## First time usage
* IP address database is populated by first scan
* vulnerability scans run once items are shown in database under `Item count`
* requires at least one IP address in database
* it may take up to 6 hours for DynamoDB to update `Item count`

## Minimising false positives
False positive alerts can occur when an 'A' record legitimately points
to an IP address in an AWS account outside your organisation,
for example a company website hosted by a third party.

To minimise false positive alerts:

* monitor Slack channel
* assess which IP addresses are legitimate
* immediately after deploying, [record IP address as OK](#record-ip-address-as-ok) for legitimate addresses
* complete before DynamoDB `DomainProtectIPsPrd` item count updates from initial value of `0`

## Optimising cost and performance
Optional Terraform variables can be entered in your CI/CD pipeline or tfvars file to optimise performance and cost:

* `ip_scan_schedule` can be reduced from `24 hours` for improved security at greater cost
* `ip_time_limit` can be reduced from `48` hours for improved security but higher risk of false positives
* `allowed_regions` can be limited to those allowed by Service Control Policies, to reduce Lambda execution time and cost
