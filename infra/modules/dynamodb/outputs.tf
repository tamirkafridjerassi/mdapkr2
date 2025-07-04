output "crew_table_arn" {
  value = aws_dynamodb_table.crew.arn
}

output "missions_table_arn" {
  value = aws_dynamodb_table.missions.arn
}

output "availability_table_arn" {
  value = aws_dynamodb_table.availability.arn
}

output "crew_table_name" {
  value = aws_dynamodb_table.crew.name
}

output "missions_table_name" {
  value = aws_dynamodb_table.missions.name
}

output "availability_table_name" {
  value = aws_dynamodb_table.availability.name
}

output "table_arns" {
  value = [
    aws_dynamodb_table.crew.arn,
    aws_dynamodb_table.missions.arn,
    aws_dynamodb_table.availability.arn
  ]
}
