variable "profile"                       { type = string }
variable "region"                        { type = string }
variable "az1"                           { type = string }
variable "az2"                           { type = string }
variable "ssh_key_path"                  { type = string }

# s3 cross account access from an ec2
variable "s3_cross_account_enabled"      { type = bool }
variable "s3_local_bucket"               { type = string }
variable "s3_local_folder"               { type = string }
variable "s3_remote_account_id"          { type = string }
variable "s3_remote_role_name"           { type = string }
variable "s3_remote_gateway_endpoint_id" { type = string }
# /s3 cross account access from an ec2
