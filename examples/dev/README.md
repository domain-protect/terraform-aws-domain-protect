# Example deployment

## Local testing
* replace the Terraform state S3 bucket fields in the command below as appropriate
* for local testing, duplicate `terraform.tfvars.example`, rename without the `.example` suffix
* enter details appropriate to your organization and save

Initialise Terraform:
```bash
terraform init -backend-config=bucket=TERRAFORM_STATE_BUCKET -backend-config=key=TERRAFORM_STATE_KEY -backend-config=region=TERRAFORM_STATE_REGION
```
If using the same Terraform state bucket for multiple environments, e.g. `dev` and `prd`:
```bash
terraform workspace new dev
```
Plan Terraform locally:
```
terraform plan
```
