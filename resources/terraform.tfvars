profile                       = "aizoon"
region                        = "eu-west-1"
az1                           = "eu-west-1a"
az2                           = "eu-west-1c"
ssh_key_path                  = "/home/emanuele/.ssh/id_rsa.pub"

# s3 cross account access from an ec2
s3_cross_account_enabled      = true
s3_remote_account_id          = "905418403597"
s3_local_bucket               = "test-s3-gdrps3-etl-np-bsn0029686-dev-eu-west-1"
s3_local_folder               = "webdac"
s3_remote_role_name           = "role-emeahub-primeur"
s3_remote_gateway_endpoint_id = "vpce-03c3497e6ad87918e"
#see also file "locals.tf"
# /s3 cross account access from an ec2
