variable "bucket_id" {
    type = string
}

variable "s3_domain" {
  type = string
} 

variable "default_lambda_arn" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "cert_arn" {
    type = string
}

variable "parse_lambda_arn" {
    type = string
}

variable "refresh_lambda_arn" {
    type = string
}

variable "bucket_arn" {
    type = string
}

variable "waf_arn" {
    type = string
}