variable "region_suffix" {
    type = string
    default = "use1"
}
variable "bucket_name_suffix" {
    type = string
}
variable "force_destroy" {
    type = bool
    default = false
}
variable "versioning" {
    type = bool
    default = true
}
variable "versioning_status" {
    type = string
    default =  "Enabled"
}
/* variable "acl" {
    type = string
    default = "private"
} */
variable "logging_bucket" {
    type = string
    default = "empty"
}
variable "logging_prefix" {
    type = string
    default = "empty"
}
variable "enabled" {
    type = string
    default = true
}
variable "enable_server_side_encryption_kms" {
    type = bool
}
variable "kms_master_key_id" {
    type = string
    default = "empty"
}
variable "bucket_tags" {
    type = map(any)
    default = null
}
variable "is_logging_bucket" {
    type = bool
    default = false
}
variable "webapp_upload" {
    type = bool
    default = false
}
variable "file_path" {
    type = string
    default = "empty"
}