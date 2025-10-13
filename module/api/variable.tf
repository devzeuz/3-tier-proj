variable "http_method"{
    default = "POST"
}

variable "function_uri" {
    default = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}