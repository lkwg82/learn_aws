Perquisites:
- terraform
- aws cli

```
terraform init
./run.sh
```

output:
```
aws_s3_bucket.bucket: Creating...
aws_iam_role.testGlueServiceRole2: Creation complete after 1s [id=terraform-20200124221457005700000001]
aws_iam_role_policy_attachment.attachGlueService: Creating...
aws_iam_role_policy_attachment.attachFullS3: Creating...
aws_glue_catalog_database.glueDatabase: Creation complete after 1s [id=695930609623:test-database2]
aws_iam_role_policy_attachment.attachFullS3: Creation complete after 1s [id=terraform-20200124221457005700000001-20200124221458515100000003]
aws_iam_role_policy_attachment.attachGlueService: Creation complete after 1s [id=terraform-20200124221457005700000001-20200124221458515100000002]
aws_s3_bucket.bucket: Creation complete after 10s [id=test-20200124-221454-43023cd7-dafb-a2fa-1449-d4e9fdffc223]
aws_s3_bucket_object.testData: Creating...
aws_s3_bucket_object.jobCode: Creating...
aws_s3_bucket_object.testData: Creation complete after 1s [id=test_data/test.csv]
aws_glue_catalog_table.glueTable: Creating...
aws_s3_bucket_object.jobCode: Creation complete after 2s [id=test.scala]
aws_glue_job.scalaJob: Creating...
aws_glue_catalog_table.glueTable: Creation complete after 2s [id=695930609623:test-database2:test-table2]
aws_glue_job.scalaJob: Creation complete after 1s [id=test-jobs-with-scala]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

bucketName = test-20200124-221454-43023cd7-dafb-a2fa-1449-d4e9fdffc223
jobName = test-jobs-with-scala
++ terraform output jobName
+ jobName=test-jobs-with-scala
++ aws glue start-job-run --job-name test-jobs-with-scala
++ jq --raw-output .JobRunId
+ jobRunId=jr_1bd0b61630254b633a05d35149b4ecd09fb91ad1188356425ea75a384ddc5c50
+ jobRunState=RUNNING

+ '[' RUNNING == RUNNING ']'
++ aws glue get-job-run --job-name test-jobs-with-scala --run-id jr_1bd0b61630254b633a05d35149b4ecd09fb91ad1188356425ea75a384ddc5c50
++ jq --raw-output .JobRun.JobRunState
+ jobRunState=RUNNING
+ sleep 10
...
<destroying>
```