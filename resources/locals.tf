locals {
  local_account_id          = data.aws_caller_identity.current.account_id
  s3_permission_policy_name = "policy-s3-${var.s3_local_folder}-write"
  s3_bucket_policy_name     = "policy-bucket-${var.s3_local_bucket}"
  s3_role_name              = "role-emeahub-primeur-s3-${var.s3_local_folder}-write"
}
