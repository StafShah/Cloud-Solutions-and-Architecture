output "lifecycle_id" {
    value = aws_s3_bucket_lifecycle_configuration.bucket_lifecycle.*.id
}