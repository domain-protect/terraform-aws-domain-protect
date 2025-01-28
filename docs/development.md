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
export EXTERNAL_ID="xxxxxxxxxxxxxxxxxx"
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
