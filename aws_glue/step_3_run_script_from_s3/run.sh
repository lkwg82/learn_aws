#!/bin/bash

set -e
set -x


terraform apply -auto-approve

jobName=$(terraform output jobName)
jobRunId=$(aws glue start-job-run --job-name $jobName | jq --raw-output '.JobRunId')

jobRunState="RUNNING"
while [ "$jobRunState" == "RUNNING" ]
do
  jobRunState=$(aws glue get-job-run --job-name $jobName --run-id $jobRunId | jq --raw-output '.JobRun.JobRunState')
  sleep 10
done

terraform destroy -auto-approve
