profile                       = "aizoon"
region                        = "eu-west-1"
az1                           = "eu-west-1a"
az2                           = "eu-west-1c"
ssh_key_path                  = "/home/emanuele/.ssh/id_rsa.pub"

# s3 cross account access from an ec2

# test using aizoon account
s3_test_cross_account_enabled              = true
s3_test_remote_account_id                  = "905418403597"
s3_test_local_bucket                       = "bucket-20251030-ncv134fkfvrtvrwn"
s3_test_local_folder                       = "folder-20251030"
s3_test_remote_role_name                   = "role-emeahub-primeur-test"
#s3_test_remote_role_name_for_xf_automation = "role-emeahub-xf-prod-automation" #given by default from stla provisioning
##s3_test_remote_user_arn_for_xf_automation  = "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
s3_test_remote_gateway_endpoint_id         = "vpce-03c3497e6ad87918e"
#see also file "locals.tf"
# /test using aizoon account

#gdrp
s3_cross_account_enabled      = true
s3_remote_account_id          = "905418403597"
s3_local_bucket               = "test-s3-gdrps3-etl-np-bsn0029686-dev-eu-west-1"
s3_local_folder               = "webdac"
s3_mockup_prod_local_bucket   = "s3-gdrps3-etl-np-bsn0029686-mockup-prod-eu-west-1"
s3_mockup_prod_local_folder   = "webdac"
s3_remote_role_name           = "role-emeahub-primeur"
s3_remote_gateway_endpoint_id = "vpce-03c3497e6ad87918e"
#see also file "locals.tf"
#/gdrp

# /s3 cross account access from an ec2
