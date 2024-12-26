variable "user_pool_id" {
  description = "ID of the Cognito User Pool"
  type        = string
}

variable "user_pool_client_name" {
  description = "Name for the Cognito User Pool Client"
  type        = string
  default     = "azure-app-client"
}

variable "azure_saml_metadata_url" {
  description = "Metadata URL for Azure AD SAML configuration"
  type        = string
}

variable "callback_urls" {
  description = "List of allowed callback URLs for the app client"
  type        = list(string)
  default     = []
}

variable "logout_urls" {
  description = "List of allowed sign-out URLs for the app client"
  type        = list(string)
  default     = []
}