resource "aws_api_gateway_rest_api" "test_api" {
  name = "test_api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  parent_id   = aws_api_gateway_rest_api.test_api.root_resource_id
  path_part   = "resource"
}

resource "aws_api_gateway_method" "test_method" {
    rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = var.http_method
  authorization = "NONE"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.test_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "test_int" {
  depends_on = [ aws_api_gateway_method.test_method ]
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  http_method = aws_api_gateway_method.test_method.http_method
  resource_id = aws_api_gateway_resource.test_resource.id
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}


#CORS Preflight (OPTIONS Method)
resource "aws_api_gateway_method" "options_hello" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
   rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.options_hello.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}


# 6️⃣ Add Method Response (so CORS headers appear)
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.options_hello.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


# 7️⃣ Integration Response with CORS headers
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.options_hello.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [ aws_api_gateway_method_response.options_response ]
}

resource "aws_api_gateway_deployment" "test_deploy" {
    rest_api_id = aws_api_gateway_rest_api.test_api.id

    triggers = {
      redeployment = sha1(jsonencode([
        aws_api_gateway_integration.test_int.id,
        aws_api_gateway_method.test_method.id,
        aws_api_gateway_resource.test_resource.id,
        aws_api_gateway_method.options_hello.id,
        aws_api_gateway_integration.options_integration.id,
        aws_api_gateway_method_response.options_response.id,
        aws_api_gateway_integration_response.options_integration_response.id
      ]))
    }

    lifecycle {
      create_before_destroy = true
    }

    depends_on = [ aws_api_gateway_integration.test_int ]
}

resource "aws_api_gateway_stage" "test_stage" {
    deployment_id = aws_api_gateway_deployment.test_deploy.id
    rest_api_id = aws_api_gateway_rest_api.test_api.id
    stage_name = "test"
}