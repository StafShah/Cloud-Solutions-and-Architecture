# Create Cognito Identity Provider for Azure AD SAML
resource "aws_cognito_identity_provider" "azure_saml" {
  user_pool_id = var.user_pool_id
  provider_name = "azureadidp"
  provider_type = "SAML"
  
  provider_details = {
    MetadataURL    = var.azure_saml_metadata_url
    IDPSignout     = "true"
  }

  attribute_mapping = {
    email = "emailaddress"
    family_name = "surname"
    given_name = "givenname"
    name = "name"
  }
}

# Create Cognito User Pool Client (Non-secret)
resource "aws_cognito_user_pool_client" "app_client" {
  name         = var.user_pool_client_name
  user_pool_id = var.user_pool_id

  allowed_oauth_flows       = ["code"]
  allowed_oauth_scopes      = ["email", "openid", "profile", "phone", "aws.cognito.signin.user.admin"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = [aws_cognito_identity_provider.azure_saml.provider_name]

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  generate_secret = false

  depends_on = [aws_cognito_identity_provider.azure_saml]
}
