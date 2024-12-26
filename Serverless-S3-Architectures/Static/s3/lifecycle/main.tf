resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {

  count = length(var.bucket_list) > 0 ? length(var.bucket_list) : 0
  bucket = length(var.bucket_list) > 0 ? element(var.bucket_list, count.index) : ""

  rule {
    id      = var.rule_id
    status  = var.status 
    transition {
      days          = var.glacier_transition_days
      storage_class = var.storage_class 
    }

    expiration {
      days = var.permament_deletion_days 
    }

    noncurrent_version_expiration {
      noncurrent_days = var.ncv_permament_deletion_days 
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.incomplete_abort_days
    }
  }
}