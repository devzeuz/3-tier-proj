variable "lambda_module_table_name"{
    type = string
}

variable "iam_lambda_role"{
    type = string
    default = "lambda_assume_role"
}