output "lambda_function_name" {
  value = aws_lambda_function.scheduler.function_name
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.scheduler.invoke_arn
}