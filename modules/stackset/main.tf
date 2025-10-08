resource "aws_cloudformation_stack_set" "domain_protect" {
  name             = var.stackset_name
  description      = "Domain Protect role and policy"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  permission_model = "SERVICE_MANAGED"
  call_as          = data.aws_organizations_organization.current.master_account_id == data.aws_caller_identity.current.account_id ? "SELF" : "DELEGATED_ADMIN"
  template_body    = file("${path.module}/templates/domain_protect.json")

  parameters = {
    AccountId  = data.aws_caller_identity.current.account_id
    PolicyName = var.policy_name
    RoleName   = var.role_name
    Project    = var.project
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  operation_preferences {
    failure_tolerance_percentage = 10
    max_concurrent_percentage    = 50
    region_concurrency_type      = "PARALLEL"
  }

  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_instances" "member_account_deployments" {
  stack_set_name = aws_cloudformation_stack_set.domain_protect.name
  regions        = [data.aws_region.current.region]
  call_as        = "DELEGATED_ADMIN"
  deployment_targets {
    organizational_unit_ids = data.aws_organizations_organization.current.roots[*].id
  }

  operation_preferences {
    failure_tolerance_percentage = 10
    max_concurrent_percentage    = 100
    region_concurrency_type      = "PARALLEL"
  }
}
