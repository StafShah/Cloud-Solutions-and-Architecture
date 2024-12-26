data "archive_file" "lambda_file" {
  type        = "zip"
  source_file = var.filepath_raw
  output_path = var.filepath_in_zip
}


resource "aws_lambda_function" "base_function" {
  count = var.create ? 1 : 0
  function_name                      = "${var.function_name}"
  filename                           = var.filepath_in_zip
  source_code_hash                   = data.archive_file.lambda_file.output_base64sha256
  description                        = var.description
  role                               = var.use_basic_role ? var.basic_lambda_execution_role : var.lambda_role_arn
  handler                            = var.package_type != "Zip" ? null : var.handler
  memory_size                        = var.memory_size
  reserved_concurrent_executions     = var.reserved_concurrent_executions ? var.concurrency_limit : null
  runtime                            = var.package_type != "Zip" ? null : var.runtime
  layers                             = var.require_layer ? var.layer_arn : null
  timeout                            = var.timeout
  kms_key_arn                        = var.kms_key_arn
  package_type                       = var.package_type
  architectures                      = var.architectures
  s3_bucket         = var.local_upload ? null : var.s3_bucket
  s3_key            = var.local_upload ? null : var.s3_key
  s3_object_version = var.local_upload ? null : var.s3_object_version
  tags = var.tags

  dynamic "environment" {
    for_each = var.environment_variables == null ? [] : [var.environment_variables]
    content {
      variables = environment.value.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }


  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.vpc_security_group_ids
      subnet_ids         = vpc_config.value.vpc_subnet_ids
    }
  }
}

resource "aws_lambda_permission" "allow_execution" {
  count = var.external_invocation ? 1 : 0
  statement_id  = var.statement_id 
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.base_function[0].function_name
  principal     = var.principal 
  source_arn    = var.source_arn
}