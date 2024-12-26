variable "create" {
    type = bool
    default = true 
}

variable "filepath_raw" {
    type = any
}

variable "filepath_in_zip" {
    type = any
}

variable "function_name" {
    type = string
}

variable "description" {
    type = string
    default = "Dev lambda"
}

variable "use_basic_role" {
    type = bool
    default = false
}

variable "basic_lambda_execution_role" {
    type = string 
    default = "{ENTER ROLE HERE}"
}

variable "lambda_role_arn" {
    type = string
}

variable "package_type" {
    type = string
    default = "Zip"
}

variable "handler" {
    type = string
}

variable "memory_size" {
    type = number
    default = 128
}

variable "reserved_concurrent_executions" {
    type = bool
    default = false
}

variable "concurrency_limit" {
    type = any
    default = -1
}

variable "runtime" {
    type = string
}

variable "require_layer" {
    type = bool
    default = false
}

variable "layer_arn" {
    type = list(string)
    default = []
}

variable "timeout" {
    type = number
    default = 15
}

//variables will be encrypted using default AWS Managed Key for Lambda 
//provide a value from Parent Module only if Master key is required
variable "kms_key_arn" {
    type = string
    default = ""
}

variable "local_upload" {
    type = bool
    default = true
}

variable "architectures" {
    type = list(string)
    default = ["x86_64"]
}


//S3 values Only required if local_upload is False
variable "s3_bucket" {
    type = string
    default = null
}

variable "s3_key" {
    type = string
    default = null
}

variable "s3_object_version" {
    type = string
    default = null
}

variable "tags" {
    type = map(string)
}

variable "environment_variables" {
    type = object({
      environment_variables = map(string)
    })
}

variable "dead_letter_config" {
    type = object({
      target_arn = string
    })
    default = null
}

variable "vpc_config" {
    type = object({
      vpc_security_group_ids = list(string)
      vpc_subnet_ids = list(string)
    })
}

variable "external_invocation" {
    type = bool
    default = false
}

variable "statement_id" {
    type = string
}

variable "principal" {
    type = string
}

variable "source_arn" {
    type = string
}