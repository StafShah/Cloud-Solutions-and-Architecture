variable "api_name" {
    type = string
}

# variable "http_method" {
#     type = string
# }

variable "paths" {
    type = list(string)
}

variable "lambda_invoke_arn" {
   type = string
}

variable "region" {
    type = string
}

variable "cognito_user_pool_arn" {
    type = string
}

variable "cfront_url" {
    type = any
}

//DO NOT CHANGE THE ORDER
variable "methods" {
    type = list(string)
    default = ["POST", "GET"]
}

//DO NOT CHANGE THE ORDER
variable "lambdapermission_statements" {
    type = list(string)
    default = ["AllowPOSTAPIExecution", "AllowGETAPIExecution"]
}

variable "lambda_function_name" {
    type = string
}

variable "description" {
    type = string
    default = "Rest API Gateway Built Using terraform"
}

variable "auth_type" {
    type = string
    default = "COGNITO_USER_POOLS"
}

variable "stage_name" {
    type = string
}