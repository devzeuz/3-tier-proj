module "s3" {
  source = "./module/s3"
  # identifier_arn = var.identifier_arn
}

module "dynamodb" {
  source = "./module/dynamodb"
}

# module "lambda" {
#   source = "./module/lambda"
#   lambda_module_table_name = module.dynamodb.dynamodb_table_name
# }

module "api" {
  source              = "./module/api"
  lambda_function_arn = module.lambda.lambda_invocation_arn
  aws_region = var.aws_region
}

# module "ssm" {
#   source = "./module/ssm"
#   api_gateway_endpoint_ssm_variable = module.api.api_gateway_endpoint
# }

