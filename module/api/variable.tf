variable "lambda_function_arn"{
    type = string
}

variable "lambda_function_name"{
    type = string
}

variable "http_method"{
    default = "POST"
}

variable "aws_region" {
   type = string
}