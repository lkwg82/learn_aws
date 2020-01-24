provider "aws" {
  version = "~> 2"
  region = "us-east-2"
  profile = "default"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_uuid" "bucketName" {}

locals{
  bucketName=format("test-%s-%s", random_uuid.bucketName.result,formatdate("YYYYMMDD-hhmmss",timestamp()))
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