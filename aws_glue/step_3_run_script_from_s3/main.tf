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
  bucketName = format("test-%s-%s", random_uuid.bucketName.result, formatdate("YYYYMMDD-hhmmss", timestamp()))
}

output "bucketName" {
  value = local.bucketName
}

resource "aws_s3_bucket" "b" {
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

