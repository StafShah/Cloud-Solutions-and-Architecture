resource "aws_s3_bucket" "root_bucket" {
  bucket = "${var.region_suffix}-${var.bucket_name_suffix}"
  force_destroy = var.force_destroy
  tags = var.bucket_tags
}


resource "aws_s3_bucket_versioning" "root_bucket" {
  count = var.enabled && var.versioning == true ? 1 : 0

  bucket                = aws_s3_bucket.root_bucket.id
  versioning_configuration {
    status     = var.versioning_status
  }
}


resource "aws_s3_bucket_logging" "root_bucket" {
  count = var.is_logging_bucket == false ? 1 : 0
  bucket = aws_s3_bucket.root_bucket.id
  target_bucket = var.logging_bucket
  target_prefix = var.logging_prefix
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_bucket" {
  count = var.enable_server_side_encryption_kms == true ? 1 : 0
  bucket = aws_s3_bucket.root_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.enable_server_side_encryption_kms == true ? var.kms_master_key_id : ""
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_object" "upload_files" {
  bucket = aws_s3_bucket.root_bucket.id
  for_each = var.webapp_upload == true ? toset(fileset("${path.module}/${var.file_path}/", "**/*.*")) : toset([])
  key = each.value
  source = "${path.module}/${var.file_path}/${each.value}"
  content_type = each.value
}



//revisit later
/* resource "aws_s3_bucket_acl" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id
  acl    = var.acl == "private" ? var.acl : "public-read"
} */
