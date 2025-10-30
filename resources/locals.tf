locals {
# test using aizoon account
#gdrp
  s3_test_permission_policy_name = "policy-s3-${var.s3_test_local_folder}-write"
  s3_test_bucket_policy_name     = "policy-bucket-${var.s3_test_local_bucket}"
  s3_test_role_name              = "role-emeahub-primeur-s3-${var.s3_test_local_folder}-write"
#/gdrp
# test using aizoon account
  s3_permission_policy_name      = "policy-s3-${var.s3_local_folder}-write"
  s3_bucket_policy_name          = "policy-bucket-${var.s3_local_bucket}"
  s3_role_name                   = "role-emeahub-primeur-s3-${var.s3_local_folder}-write"
# /test using aizoon account
}
