provider "aws" {
  version = "~> 2"
  region = "us-east-2"
  profile = "default"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_uuid" "bucketName" {}

locals {
  bucketName = format("test-%s-%s", formatdate("YYYYMMDD-hhmmss", timestamp()),random_uuid.bucketName.result)
}

output "bucketName" {
  value = local.bucketName
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucketName
  acl = "private"

  tags = {
    Name = "My bucket"
    Environment = "Dev"
  }

  lifecycle_rule {
    enabled = true
    expiration {
      days = 10
    }
  }

  force_destroy = true
}

resource "aws_iam_role" "testGlueServiceRole2" {
  // language=json
  assume_role_policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":{"Service":"glue.amazonaws.com"},
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachFullS3" {
  role = aws_iam_role.testGlueServiceRole2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "attachGlueService" {
  role = aws_iam_role.testGlueServiceRole2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_s3_bucket_object" "jobCode" {
  bucket = aws_s3_bucket.bucket.bucket
  key = "test.scala"
  source = "test.scala"
  etag = filemd5("test.scala")
}

resource "aws_s3_bucket_object" "testData" {
  bucket = aws_s3_bucket.bucket.bucket
  key = "test_data/test.csv"
  source = "test_data.csv"
  etag = filemd5("test.scala")
}

resource "aws_glue_job" "scalaJob" {
  name = "test-jobs-with-scala"
  role_arn = aws_iam_role.testGlueServiceRole2.arn

  command {
    script_location = format("s3://%s/%s",aws_s3_bucket_object.jobCode.bucket,aws_s3_bucket_object.jobCode.key)
  }

  timeout = 3
  max_capacity = 1
  glue_version = "1.0"

  default_arguments = {
    "--job-language" = "scala"
    "--job-bookmark-option" : "job-bookmark-disable",
    "--TempDir" : "s3://${aws_s3_bucket.bucket.bucket}/temp",
    "--class" : "GlueApp",
  }
}

resource "aws_glue_catalog_database" "glueDatabase" {
  name = "test-database2"
}

resource "aws_glue_catalog_table" "glueTable" {
  name = "test-table2"
  database_name = aws_glue_catalog_database.glueDatabase.name

  parameters = {
    classification = "csv"
  }

  partition_keys {
    comment = ""
    name = "id"
    type = "string"
  }
  storage_descriptor {
    columns {
      comment = ""
      name = "name"
      type = "smallint"
    }

    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    location = format("s3://%s/%s",aws_s3_bucket.bucket.bucket,aws_s3_bucket_object.testData.key)
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    ser_de_info {
      name = "x"
      parameters = {
        separatorChar = ","
      }
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
    }
  }
}