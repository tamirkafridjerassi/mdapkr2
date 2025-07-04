variable "crew_table_name" {
  type        = string
  description = "Name of the crew DynamoDB table"
}

variable "missions_table_name" {
  type        = string
  description = "Name of the missions DynamoDB table"
}

variable "availability_table_name" {
  type        = string
  description = "Name of the availability DynamoDB table"
}

variable "dynamodb_table_arns" {
  type        = list(string)
  description = "List of DynamoDB table ARNs for access"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the zipped Lambda deployment package"
}
