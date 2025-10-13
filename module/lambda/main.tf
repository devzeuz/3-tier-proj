data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda"{
    name = var.iam_lambda_role
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "archive_file" "zip-lambda"{
    type = "zip"
    source_file = "${path.module}/src/lambda-function.py"
    output_path = "${path.module}/src/lambda-function.zip"
}

resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    filename = archive_file.zip-lambda.output_path
    role = aws_iam_role.iam_for_lambda.arn
    handler = "lambda-function.lambda_handler"
    runtime = "python3.9"
    source_code_hash = archive_file.zip-lambda.output_base64sha256

    environment {
      variables = {
        ENVIRONMENT = "development"
      LOG_LEVEL   = "info"
      DYNAMO_DB = var.lambda_module_table_name
      }
    }

    tags = {
        name = "my-lambda-function"
        environment = "dev"
    }
}