provider "aws" {
  version = "~> 2"
  region = "us-east-2"
  profile = "default"
}

variable "bucketName" {
  type =string
}

resource "aws_s3_bucket" "b" {
  // we easily exceed the max number of 61 chars, so it is truncated
  bucket = substr(format("test-%s",var.bucketName),0,60)
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}