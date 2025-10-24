# Integration Tests - Deployment

[Integration Tests](../docs/integration-tests.md) have been implemented to provide comprehensive end-to-end pipeline tests to ensure we can be confident as to whether an update has affected the system functionality.

This page details the process for developing and testing deployment integration tests.

## Create integration test role in Route53 test account

* Create an IAM role in the Route53 test account
* Add a trust policy for the Security Audit account, optionally with an External ID
* Add this policy,replacing the example with your Hosted Zone ID
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Route53write",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/ZZZZ12345678ZZ"
        },
        {
            "Sid": "Route53Read",
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        }
    ]
}
```

## Configure development environment - MacOS / Linux

* create virtual environment
```bash
python -m venv .venv
```
* activate virtual environment
```bash
source .venv/bin/activate
```
* install dependencies
```powershell
pip install -r requirements-dev.txt
```
* set environment variables for dev environment, e.g.
```bash
export PROJECT=domain-protect
export ENVIRONMENT=dev
export ROUTE53_ACCOUNT="12345678901"
export TEST_ROLE_NAME="domain-protect-integration-test"
export ZONE_NAME="example.com"
export ZONE_ID="ZZZZ12345678ZZ"
export TEST_ROLE_EXTERNAL_ID="xxxxxxxxxxxxxxxxxx"
export AWS_REGION="eu-west-1"
export CLOUDFLARE_API_KEY: "xxxxxxxxxxxxxxxxxx"
export CLOUDFLARE_EMAIL: "me@example.com"
export CLOUDFLARE_ZONE_NAME="example.net"
```
* copy and paste AWS macOS / Linux CLI variables for the security audit account to terminal

## Configure development environment - Windows

* create virtual environment
```powershell
python -m venv .venv
```
* activate virtual environment
```powershell
.venv/scripts/activate
```
* install dependencies
```powershell
pip install -r requirements-dev.txt
```
* set environment variables for dev environment, e.g.
```powershell
$env:PROJECT="domain-protect"
$env:ENVIRONMENT="dev"
$env:ROUTE53_ACCOUNT="12345678901"
$env:TEST_ROLE_NAME="domain-protect-integration-test"
$env:ZONE_NAME="example.com"
$env:ZONE_ID="ZZZZ12345678ZZ"
$env:TEST_ROLE_EXTERNAL_ID="xxxxxxxxxxxxxxxxxx"
$env:AWS_REGION="eu-west-1"
$env:CLOUDFLARE_API_KEY="xxxxxxxxxxxxxxxxxx"
$env:CLOUDFLARE_EMAIL="me@example.com"
$env:CLOUDFLARE_ZONE_NAME="example.net"
```
* copy and paste AWS PowerShell variables for the security audit account to terminal

## Run integration tests locally

* test integration locally
```python
pytest -v integration_tests/deployment
```
