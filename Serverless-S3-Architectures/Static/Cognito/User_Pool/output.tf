output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_arn" {
  value       = aws_cognito_user_pool.user_pool.arn
  description = "ARN of the created Cognito User Pool"
}
