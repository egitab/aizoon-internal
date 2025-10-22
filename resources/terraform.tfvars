profile                        = "aizoon"
region                         = "eu-west-1"
az1                            = "eu-west-1a"
az2                            = "eu-west-1c"
ssh_key_path                   = "/home/emanuele/.ssh/id_rsa.pub"

# s3 cross account access from an ec2
s3_cross_account_enabled       = false
s3_local_bucket               = "test-s3-gdrps3-etl-np-bsn0029686-dev-eu-west-1"
s3_local_folder               = "webdac"
s3_remote_account_id           = "905418403597"
##dest_permission_policy_name="policy-s3-webdac-write"
##dest_trust_policy_name="policy-assumerole-from-emeahub-primeur"
#s3_local_role_name             = "role-emeahub-primeur-TEST"
#s3_local_instance_profile_name = "ec2p-emeahub-primeur-TEST"
#s3_local_instance_name         = "ec2-emeahub-xf-prod-0-eehub-01-steng01-eu-west-3a"
#see also file "locals.tf"
# /s3 cross account access from an ec2
