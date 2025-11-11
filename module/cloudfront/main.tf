resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.s3_bucket_id}"
  description                       = "OAC for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for S3 content"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"  # Use only North America and Europe

  # S3 Origin Configuration
  origin {
    domain_name              = var.s3_bucket_domain
    origin_id                = "${var.s3_bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  # Default Cache Behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.s3_bucket_id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

 viewer_certificate {
        cloudfront_default_certificate = true
    }
}
