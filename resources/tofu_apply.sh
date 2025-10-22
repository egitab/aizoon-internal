#!/bin/bash
source ../vars.env
profile=$(cat terraform.tfvars | grep ^profile | awk -F\" '{ print $2 }')
if [ -z $profile ]; then
  echo "Profile invalid or not specified, please check terraform.tfvars file."
  exit 1
fi

mkdir -p ./logs

#echo "Running: tofu apply -auto-approve -state-out=terraform.${profile}.tfstate ${profile}-plan.out"
echo "Running: tofu apply -auto-approve ${profile}-plan.out"
sleep 1
tofu apply -auto-approve ${profile}-plan.out 2>&1 | tee logs/tofu-apply-${profile}-$(date +%Y%m%d%H%M%S).log
