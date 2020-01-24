#!/bin/bash

set -e
set -x

export TF_VAR_bucketName=$(echo $RANDOM$RANDOM$RANDOM$RANDOM$RANDOM | sha256sum | cut -d\  -f1)

terraform apply -auto-approve

aws s3 ls | grep "${TF_VAR_bucketName:0:5}"

terraform destroy -auto-approve

if [[ $(aws s3 ls | grep "${TF_VAR_bucketName:0:5}") ]]; then
  echo failed to remove s3
  exit 1
fi