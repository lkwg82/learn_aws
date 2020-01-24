Perquisites:
- terraform
- aws cli

```
terraform init
./run.sh
```

output:
```
++ echo 23692865515192532916743
++ sha256sum
++ cut '-d ' -f1
+ export TF_VAR_bucketName=f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381de635a2b14
+ TF_VAR_bucketName=f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381de635a2b14
+ terraform apply -auto-approve
aws_s3_bucket.b: Refreshing state... [id=test-4852b166bfe160945de7ffbe7d30bf55494720099ff7d8843c71267]
aws_s3_bucket.b: Destroying... [id=test-4852b166bfe160945de7ffbe7d30bf55494720099ff7d8843c71267]
aws_s3_bucket.b: Destruction complete after 1s
aws_s3_bucket.b: Creating...
aws_s3_bucket.b: Creation complete after 10s [id=test-f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381d]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
+ aws s3 ls
+ grep f4a5d
2020-01-24 13:39:11 test-f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381d
+ terraform destroy -auto-approve
aws_s3_bucket.b: Refreshing state... [id=test-f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381d]
aws_s3_bucket.b: Destroying... [id=test-f4a5dc98f778275494b9b9684f59acc5dd57fa294f41822d659381d]
aws_s3_bucket.b: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
++ aws s3 ls
++ grep f4a5d
+ [[ -n '' ]]
```