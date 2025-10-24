# Development

## adding new checks
* new checks are added to the relevant Python module in [utils](../utils/)

## adding new Lambda functions
* add Python code file with same name as the subdirectory
* add the name of the file without extension to ```var.lambdas``` in [variables.tf](variables.tf)
* add a subdirectory within the modules/lambda/build directory, following the existing naming pattern
* add a .gitkeep file into the new directory
* update the .gitignore file following the pattern of existing directories
* apply Terraform

## testing Lambda functions locally (MacOS / Linux)
* create virtual environment
```
cd modules\terraform-aws-ca-lambda
python -m venv .venv
```
* activate virtual environment
```
source .venv/bin/activate
```
* install dependencies
```
pip install -r requirements-dev.txt
```
* set environment variables for dev environment
```
export CLOUDFLARE_API_KEY="xxxxxxxxxxxxxxxxxx"
export CLOUDFLARE_EMAIL="me@example.com"
export ORG_PRIMARY_ACCOUNT="123456789012"
export SECURITY_AUDIT_ROLE_NAME="domain-protect-audit"
export PROJECT="domain-protect"
export SNS_TOPIC_ARN="arn:aws:sns:eu-west-1:123456789012:domain-protect-dev"
export ENVIRONMENT="dev"
export PRODUCTION_ENVIRONMENT="prd"
export BUGCROWD="disabled"
export BUGCROWD_API_KEY=""
export BUGCROWD_EMAIL=""
export BUGCROWD_STATE="unresolved"
export HACKERONE="enabled"
export HACKERONE_API_TOKEN="xxxxxxxxxxxxxxxxxx"
```
* copy and paste AWS macOS / Linux CLI variables to terminal
* test Lambda function locally
* enter `python`
```
from lambda_code.cloudflare_scan.cloudflare_scan import lambda_handler
lambda_handler({},{})
```

## testing Lambda functions locally (Windows)
* create virtual environment
```
cd modules\terraform-aws-ca-lambda
python -m venv .venv
```
* activate virtual environment
```
.venv/scripts/activate
```
* install dependencies
```
pip install -r requirements-dev.txt
```
* set environment variables for dev environment
```
$env:ALLOWED_REGIONS="'eu-west-1', 'us-east-1'"
$env:AWS_IP_ADDRESSES="18.96.8.1"
$env:AWS_DEFAULT_REGION="eu-west-1"
$env:AWS_REGION="eu-west-1"
$env:ORG_PRIMARY_ACCOUNT="123456789012"
$env:SECURITY_AUDIT_ROLE_NAME="domain-protect-audit"
$env:PROJECT="domain-protect"
$env:SNS_TOPIC_ARN="arn:aws:sns:eu-west-1:123456789012:domain-protect-dev"
$env:ENVIRONMENT="dev"
$env:PRODUCTION_ENVIRONMENT="prd"
$env:BUGCROWD="disabled"
$env:HACKERONE="enabled"
$env:HACKERONE_API_TOKEN="xxxxxxxxxxxxxxxxxx"
$env:IP_TIME_LIMIT="48"
```
* copy and paste AWS PowerShell variables to PowerShell terminal
* test Lambda function locally
* enter `python`
```
from lambda_code.scan_ips.scan_ips import lambda_handler
lambda_handler({"Id": "123456789012", "Name": "MyAWSAccount"},{})
```
