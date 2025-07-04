terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  suffix = random_id.suffix.hex
}

# -------------------------
# S3 Buckets Module
# -------------------------
module "s3" {
  source = "./modules/s3"
  suffix = local.suffix
}

# -------------------------
# DynamoDB Tables Module
# -------------------------
module "dynamodb" {
  source = "./modules/dynamodb"
}

# -------------------------
# IAM Role and Policy Module
# -------------------------
module "iam" {
  source = "./modules/iam"

  dynamodb_table_arns = [
    module.dynamodb.crew_table_arn,
    module.dynamodb.missions_table_arn,
    module.dynamodb.availability_table_arn
  ]
}

# -------------------------
# Lambda Module
# -------------------------
module "lambda" {
  source = "./modules/lambda"

  crew_table_name         = module.dynamodb.crew_table_name
  missions_table_name     = module.dynamodb.missions_table_name
  availability_table_name = module.dynamodb.availability_table_name
  dynamodb_table_arns     = module.dynamodb.table_arns

  lambda_zip_path = "${path.module}/../backend/build/lambda.zip"
}

# -------------------------
# API Gateway Module
# -------------------------
module "api_gateway" {
  source = "./modules/api_gateway"

  name                 = "mdapkr2-api"
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
}

# -------------------------
# Outputs
# -------------------------
output "api_url" {
  value = module.api_gateway.api_url
}

output "frontend_bucket" {
  value = module.s3.frontend_bucket
}

output "logs_bucket" {
  value = module.s3.logs_bucket
}
