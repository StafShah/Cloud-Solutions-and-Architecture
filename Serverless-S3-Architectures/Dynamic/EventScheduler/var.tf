variable "region_prefix" {
    type = string
    default = "use1"
}

variable "suffix" {
    type = string
}

variable "description" {
    type = string
}

variable "rate" {
    type = string
    default = "rate(5 minutes)"
}

variable "target_id" {
    type = string
}

variable "target_arn" {
    type = string
}

variable "state" {
  type = string
  default = "ENABLED"
}