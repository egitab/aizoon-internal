#!/bin/bash
source ../vars.env
profile=$(cat terraform.tfvars | grep ^profile | awk -F\" '{ print $2 }')
if [ -z $profile ]; then
  echo "Profile invalid or not specified, please check terraform.tfvars file." 
  exit 1
fi
#echo "Running: tofu plan -out ${profile}-plan.out -state=terraform.${profile}.tfstate"
echo "Running: tofu plan -out ${profile}-plan.out"
sleep 1
tofu plan -out ${profile}-plan.out
