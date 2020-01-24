Perquisites:
- terraform
- aws cli

```
terraform init
./run.sh
```

output:
```
+ terraform apply -auto-approve
random_uuid.bucketName: Refreshing state... [id=b403c973-c2a9-64ef-9ab1-e43cf7b9c267]
aws_s3_bucket.b: Refreshing state... [id=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140645]
aws_s3_bucket.b: Destroying... [id=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140645]
aws_s3_bucket.b: Destruction complete after 1s
aws_s3_bucket.b: Creating...
aws_s3_bucket.b: Still creating... [10s elapsed]
aws_s3_bucket.b: Creation complete after 10s [id=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

bucketName = test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
++ terraform output bucketName
+ bucketName=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
+ aws s3api wait bucket-exists --bucket test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
++ tempfile
+ file=/tmp/fileDZRqFV
+ echo test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
+ aws s3 cp /tmp/fileDZRqFV s3://test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830/test.txt
upload: ../../../../../../../../tmp/fileDZRqFV to s3://test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830/test.txt
+ aws s3 ls s3://test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
2020-01-24 15:08:46         58 test.txt
+ terraform destroy -auto-approve
random_uuid.bucketName: Refreshing state... [id=b403c973-c2a9-64ef-9ab1-e43cf7b9c267]
aws_s3_bucket.b: Refreshing state... [id=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830]
aws_s3_bucket.b: Destroying... [id=test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830]
aws_s3_bucket.b: Destruction complete after 3s
random_uuid.bucketName: Destroying... [id=b403c973-c2a9-64ef-9ab1-e43cf7b9c267]
random_uuid.bucketName: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
++ aws s3 ls
++ grep test-b403c973-c2a9-64ef-9ab1-e43cf7b9c267-20200124-140830
+ [[ -n '' ]]
✔ ~/.../step_2_put_data_into_s3 [master {origin/master}|●4✚ 3]
```