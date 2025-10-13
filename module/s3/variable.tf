variable "aws_s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default = "s3-development-bucket-12345"
}

variable "index_document" {
  description = "The index document for the S3 website"
  type        = string
  default     = "index.html" 
}

variable error_document {
  description = "The error document for the S3 website"
  type        = string
  default     = "error.html" 
}

variable "identifier_arn"{
  type = string
}