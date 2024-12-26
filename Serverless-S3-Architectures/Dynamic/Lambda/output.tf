output "lambda_arn" {
  value = aws_lambda_function.base_function[*].arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.base_function[*].invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.base_function[*].function_name
}