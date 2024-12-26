output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.app_client.id
}

output "saml_provider_name" {
  value = aws_cognito_identity_provider.azure_saml.provider_name
}