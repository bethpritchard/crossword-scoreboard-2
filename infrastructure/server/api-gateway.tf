resource "aws_api_gateway_rest_api" "main" {
  name        = "scoreboard-rest-api"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]

  }
}

// Mock POST method
resource "aws_api_gateway_resource" "test" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "test"
}

resource "aws_api_gateway_method" "test" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.test.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type" = true
  }

}

resource "aws_api_gateway_integration" "test" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.test.id
  http_method = aws_api_gateway_method.test.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "test" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.test.id
  http_method = aws_api_gateway_method.test.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "test" {
  depends_on  = [aws_api_gateway_integration.test]
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.test.id
  http_method = aws_api_gateway_method.test.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "Success!"
  }

}

resource "aws_api_gateway_deployment" "test" {
  depends_on  = [aws_api_gateway_integration.test]
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "test"
  triggers = {
    redeployment = sha256(jsonencode(aws_api_gateway_integration.test))
  }
}
