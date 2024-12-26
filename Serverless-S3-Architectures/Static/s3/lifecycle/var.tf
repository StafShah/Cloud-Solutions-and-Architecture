variable "bucket_list" {
    type = list(string)
}
variable "permament_deletion_days" {
    type = number 
    default = 2555
}
variable "glacier_transition_days" {
    type = number
    default = 14
}
variable "rule_id" {
    type = string
}
variable "storage_class" {
    type = string
    default = "GLACIER" 
}
variable "status" {
    type = string
    default = "Enabled"
}
variable "ncv_permament_deletion_days" {
    type = number
    default = 60
}
variable "incomplete_abort_days" {
    type = number
    default = 7
}