terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0"  # Última versión estable
    }
  }

  backend "s3" {
    bucket                  = "tach-state20250708211907112200000002"
    key                     = "dev/tach/terraform.tfstate"
    region                  = "us-east-1"
    encrypt                 = true
    kms_key_id              = "8562e1fc-529e-4b43-99bb-fd4d4b4302b4"
    dynamodb_table          = "tfRemoteStateLock"
  }
}

## Configure the AWS Provider
#provider "aws" {
#  region = var.aws_region
#}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}