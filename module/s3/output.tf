output "bucket_endpoint"{
   value = aws_s3_bucket_website_configuration.app_bucket_website.website_endpoint
}

output "bucket_arn"{
   value = aws_s3_bucket.app_bucket.arn
}