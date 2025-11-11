resource "aws_s3_bucket" "app_bucket" {
     bucket = var.aws_s3_bucket_name

  tags = {
    Name        = var.aws_s3_bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_public_access" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
}

resource "aws_s3_bucket_website_configuration" "app_bucket_website" {
  bucket = aws_s3_bucket.app_bucket.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id

  policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.app_bucket.arn}/*"

      Condition = {
        StringEquals = {
          "aws:SourceArn" = var.cloudfrontarn
        }
      }
        }
      ]  
  })

  depends_on = [ aws_s3_bucket_public_access_block.app_bucket_public_access  ]
}

# resource "aws_s3_object" "index" {
#   bucket = aws_s3_bucket.app_bucket.bucket
#   key    = "index.html"
#   source = "${path.module}/src/index.html"
#   acl    = "public-read"
#   content_type = "text/html"

#   depends_on = [ aws_s3_bucket.app_bucket, aws_s3_bucket_website_configuration.app_bucket_website ]
# }