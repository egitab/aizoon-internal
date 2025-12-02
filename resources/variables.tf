variable "profile"                       { type = string }
variable "region"                        { type = string }
variable "az1"                           { type = string }
variable "az2"                           { type = string }
variable "ssh_key_path"                  { type = string }

### s3 cross account access from an ec2

# test using aizoon account
variable "s3_test_cross_account_enabled" {
  type = bool
  default = false
}
variable "s3_test_local_bucket" {
  type = string
  default = null
}
variable "s3_test_local_folder" {
  type = string
  default = null
}
variable "s3_test_remote_account_id" {
  type = string
  default = null
}
variable "s3_test_remote_role_name" {
  type = string
  default = null
}
variable "s3_test_remote_gateway_endpoint_id" {
  type = string
  default = null
}
# /test using aizoon account

#gdrp
variable "s3_cross_account_enabled" {
  type = bool
  default = false
}
variable "s3_local_bucket" {
  type = string
  default = null
}
variable "s3_local_folder" {
  type = string
  default = null
}
variable "s3_mockup_prod_local_bucket" {
  type = string
  default = null
}
variable "s3_mockup_prod_local_folder" {
  type = string
  default = null
}
variable "s3_remote_account_id" {
  type = string
  default = null
}
variable "s3_remote_role_name" {
  type = string
  default = null
}
variable "s3_remote_gateway_endpoint_id" {
  type = string
  default = null
}
#/gdrp

### /s3 cross account access from an ec2
