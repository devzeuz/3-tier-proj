module "s3" {
  source        = "./module/s3"
  cloudfrontarn = ""
}

module "dynamodb" {
  source = "./module/dynamodb"
}

module "lambda" {
  source                   = "./module/lambda"
  lambda_module_table_name = module.dynamodb.dynamodb_table_name
}

module "api" {
  source              = "./module/api"
  lambda_function_arn = module.lambda.lambda_invocation_arn
  aws_region          = var.aws_region
}

# module "ssm" {
#   source = "./module/ssm"
#   api_gateway_endpoint_ssm_variable = module.api.api_gateway_endpoint
# }

module "cloudfront" {
  source       = "./module/cloudfront"
  s3_bucket_id = module.s3.aws_s3_bucket.app_bucket.id
  s3_bucket_domain = module.s3.aws_s3_bucket.app_bucket.bucket_regional_domain_name
}

output "gateway-endpoint" {
  value = module.api.api_gateway_endpoint
}

output "cloudfront_domain_name"{
  value = module.cloudfront.cloudfront_domain_name
}


