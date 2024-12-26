variable "create_table" {
    type = bool
    default = true
}

variable "table_name" {
    type = string
}

variable "billing_mode" {
    type = string
    default = "PAY_PER_REQUEST"
}

variable "hash_key" {
    type = any
}

variable "range_key" {
    type = any
    default = null
}

variable "read_capacity" {
    type = number
    default = 10
}

variable "write_capacity" {
    type = number
    default = 20
}

variable "stream_enabled" {
   type = bool
   default = false
}

variable "stream_view_type" {
    type = string
    default = "NEW_AND_OLD_IMAGES"
}

variable "table_class" {
    type = string
    default = "STANDARD"
}

variable "deletion_protection_enabled" {
    type = bool
    default = false
}

variable "point_in_time_recovery_enabled" {
    type = bool
    default = true
}

variable "attributes" {
    type = any
}

variable "replica_regions" {
    type = any
}

variable "server_side_encryption_enabled" {
    type = bool
    default = true
}

variable "server_side_encryption_kms_key_arn" {
    type = string
}