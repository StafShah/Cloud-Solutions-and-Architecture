variable "user_pool_name" {
  description = "Name for the Cognito User Pool"
  type        = string
  default     = "azure-saml-user-pool"
}

variable "user_pool_domain" {
  description = "Domain prefix for the Cognito User Pool (e.g., 'my-app-domain')"
  type        = string
}
