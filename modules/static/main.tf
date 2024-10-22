resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  tags = {
    project = var.project
    env     = var.env
    name    = var.name
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

locals {
  s3_origin_id = "${var.name}S3Origin"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  enabled = true
  aliases = [var.name]
  custom_error_response {
    error_code         = 403
    response_page_path = "/index.html"
    response_code      = 200
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 259200
    default_ttl            = 259200
    max_ttl                = 31536000
    compress               = var.compress

    dynamic "function_association" {
      for_each = var.enable_credentials && var.credentials != "" ? [{}] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.basic_auth_function[0].arn
      }
    }
  }

  price_class = var.price_class
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
  tags = {
    project = var.project
    env     = var.env
    name    = var.name
  }
}

resource "aws_route53_record" "root_domain" {
  zone_id = var.zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_function" "basic_auth_function" {
  count   = var.credentials != "" ? 1 : 0
  name    = "${var.slug}_basic-auth-func-${var.env}"
  runtime = "cloudfront-js-2.0"

  code = <<EOT
function handler(event) {
  var request = event.request;
  var headers = request.headers;

  if (headers.authorization && headers.authorization.value === 'Basic ${var.credentials}') {
    return request;
  }

  return {
    statusCode: 401,
    statusDescription: 'Unauthorized',
    headers: {
      'www-authenticate': { value: 'Basic realm="auth required"' }
    }
  };
}
EOT
}