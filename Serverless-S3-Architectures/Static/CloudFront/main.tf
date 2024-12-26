# Create CloudFront origin access control
resource "aws_cloudfront_origin_access_control" "demo_origin_access_control" {
  name                            = "${var.bucket_id}.s3.us-east-1.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                = "no-override"
  signing_protocol                = "sigv4"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "demo_distribution" {
  origin {
    domain_name              = var.s3_domain
    origin_access_control_id = aws_cloudfront_origin_access_control.demo_origin_access_control.id
    origin_id                = "${var.bucket_id}.s3.us-east-1.amazonaws.com"
  }
  web_acl_id = var.waf_arn 
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Local TF Distribuution"
  default_root_object = "index.html"
# default cache behavior
  default_cache_behavior {
    cache_policy_id  = "{Filler}"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "${var.bucket_id}.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "allow-all"
    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.default_lambda_arn
      include_body = false
    }
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress = true
   }
   ordered_cache_behavior {
    # cache_policy_id  = ""
    path_pattern           = "/parseauth"
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = "${var.bucket_id}.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "allow-all"
    compress = true

    default_ttl = 3600
    min_ttl     = 0
    max_ttl     = 86400

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.parse_lambda_arn
      include_body = false
    }
   }
   ordered_cache_behavior {
    # cache_policy_id  = ""
    path_pattern           = "/refreshauth"
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = "${var.bucket_id}.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "allow-all"
    compress = true

    default_ttl = 3600
    min_ttl     = 0
    max_ttl     = 86400

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.refresh_lambda_arn
      include_body = false
    }
  }

 
  price_class = "PriceClass_200"

    restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    acm_certificate_arn = var.cert_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}

# Grant read permission to the CloudFront origin access identity
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.demo_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}