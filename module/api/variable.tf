# variable "lambda_function_arn"{
#     type = string
# }

# variable "http_method"{
#     default = "POST"
# }

# variable "aws_region" {
#    type = string
# }

# locals {
#     function_uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
# }