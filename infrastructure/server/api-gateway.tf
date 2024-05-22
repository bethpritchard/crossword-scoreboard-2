resource "aws_api_gateway_rest_api" "main" {
  name        = "scoreboard-rest-api"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "db" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "db"
}

// POST method


resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.db.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type"                 = true
    "method.request.header.Access-Control-Allow-Headers" = true
  }

}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.db.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = aws_lambda_function.update_score_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"                 = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "post" {
  depends_on  = [aws_api_gateway_integration.post]
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.post.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

// GET method

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.db.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.db.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_score_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"                 = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "get" {
  depends_on  = [aws_api_gateway_integration.get]
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

// OPTIONS method for CORS preflight

resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.db.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,PUT,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_deployment" "db" {
  depends_on = [
    aws_api_gateway_integration.post,
    aws_api_gateway_integration.get,
    aws_api_gateway_integration.options
  ]
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "v1"
}
