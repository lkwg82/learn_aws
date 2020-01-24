#!/bin/bash

set -e
set -x


terraform apply -auto-approve

bucketName=$(terraform output bucketName)
aws s3api wait bucket-exists --bucket $bucketName

# create data
file=$(tempfile)
echo $bucketName > $file

aws s3 cp "$file" s3://"$bucketName"/test.txt
aws s3 ls "s3://$bucketName"

terraform destroy -auto-approve

if [[ $(aws s3 ls | grep "${bucketName}") ]]; then
  echo failed to remove s3
  exit 1
fi