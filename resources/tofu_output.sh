#!/bin/bash
source ../vars.env
profile=$(cat terraform.tfvars | grep ^profile | awk -F\" '{ print $2 }')
if [ -z $profile ]; then
  echo "Profile invalid or not specified, please check terraform.tfvars file."
  exit 1
fi

echo "Running: tofu output -state \"terraform.tfstate\" -var-file=\"terraform.tfvars\""
tofu output -state "terraform.tfstate" -var-file="terraform.tfvars"
