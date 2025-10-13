module "s3" {
  source = "./module/s3"
  identifier_arn = module.s3.identifier_arn
}

module "dynamodb" {
  source = "./module/dynamodb"
}

module "lambda" {
  source = "./module/lambda"
  lambda_module_table_name = module.dynamodb.dynamodb_table_name
}

module "api" {
  source              = "./module/api"
  lambda_function_arn = module.lambda.lambda_invocation_arn
}

