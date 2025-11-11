variable "lambda_function_arn"{
     type = string
}

variable "lambda_invoke_arn"{
     type = string
}

variable "http_method"{
    default = "POST"
}

variable "aws_region" {
   type = string
}