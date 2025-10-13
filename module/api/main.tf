resource "aws_api_gateway_rest_api" "test_api" {
  name = "test_api"
}

resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  parent_id   = aws_api_gateway_rest_api.test_api.root_resource_id
  path_part   = "resource"
}

resource "aws_api_gateway_method" "test_method" {
    rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "test_int" {
    depends_on = [aws_api_gateway_method.test_method]
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  http_method = aws_api_gateway_method.test_method.http_method
  resource_id = aws_api_gateway_resource.test_resource.id
  type = "AWS_PROXY"
  uri = var.function_uri
}

resource "aws_api_gateway_deployment" "test_deploy" {
    rest_api_id = aws_api_gateway_rest_api.test_api.id

    triggers = {
      redeployment = sha1(jsonencode(aws_api_gateway_integration.test_int))
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "test_stage" {
    deployment_id = aws_api_gateway_deployment.test_deploy.id
    rest_api_id = aws_api_gateway_rest_api.test_api.id
    stage_name = "test"
}