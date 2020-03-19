provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "on-prem/s3_test_finale.tfstates"
    region  = "eu-west-1"
    encrypt = "true"
  }
}

# CALL TARGET MODULE 
module "s3" {
  # https://github.com/hashicorp/terraform/issues/21606
  source = "git::https://github.com/dev-minds/tf_modules.git//fm_s3_mod?ref=master"
  bucket_name = [var.bucket_name]
}