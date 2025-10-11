resource "aws_api_gateway_rest_api" "test-api" {
  name = "test-api"
}

resource "aws_api_gateway_resource" "test-resource" {
  rest_api_id = aws_api_gateway_rest_api.test-api.id
  parent_id   = aws_api_gateway_rest_api.test-api.root_resource_id
  path_part   = "test"
}

resource "aws_api_gateway_method" "test-method" {
    rest_api_id = aws_api_gateway_rest_api.test-api.id
  resource_id = aws_api_gateway_resource.test-resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "test-int" {
  http_method = aws_api_gateway_method.test-method.http_method
  resource_id = aws_api_gateway_resource.test-resource.id
  rest_api_id = aws_api_gateway_rest_api.test-api.id
  type = "AWS_PROXY"
  uri = var.lambda_function_arn
}

resource "aws_api_gateway_deployment" "test-deploy" {
    rest_api_id = aws_api_gateway_rest_api.test-api.id

    triggers = {
      redeployment = sha1(jsonencode(aws_api_gateway_integration.test-int))
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "test-stage" {
    deployment_id = aws_api_gateway_deployment.test-deploy.id
    rest_api_id = aws_api_gateway_rest_api.test-api.id
    stage_name = "test"
}