resource "aws_api_gateway_rest_api" "main" {
  name        = "scoreboard-rest-api"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// Mock POST method
resource "aws_api_gateway_resource" "db" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "db"
}

resource "aws_api_gateway_method" "db" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.db.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type"                 = true
    "method.request.header.Access-Control-Allow-Headers" = true
  }

}

resource "aws_api_gateway_integration" "db" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.db.id
  http_method             = aws_api_gateway_method.db.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = aws_lambda_function.update_score_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "db" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.db.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"                 = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "db" {
  depends_on  = [aws_api_gateway_integration.db]
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.db.http_method
  status_code = aws_api_gateway_method_response.db.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

// OPTIONS method for CORS preflight
resource "aws_api_gateway_method" "db_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.db.id
  http_method   = "OPTIONS"
  authorization = "NONE"

}

resource "aws_api_gateway_integration" "db_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.db_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "db_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.db_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "db_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.db.id
  http_method = aws_api_gateway_method.db_options.http_method
  status_code = aws_api_gateway_method_response.db_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST, PUT, GET'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.db_options,
    aws_api_gateway_integration.db_options,
  ]
}

resource "aws_api_gateway_deployment" "db" {
  depends_on = [
    aws_api_gateway_integration.db,
    aws_api_gateway_integration.db_options,
  ]
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "v1"
}

# resource "aws_api_gateway_stage" "db" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   stage_name    = "v1"
#   deployment_id = aws_api_gateway_deployment.db.id

#   tags = {
#     Environment = "production"
#   }
# }
# resource "aws_api_gateway_rest_api" "main" {
#   name        = "scoreboard-rest-api"
#   description = "API Gateway"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# // Mock POST method
# resource "aws_api_gateway_resource" "db" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_rest_api.main.root_resource_id
#   path_part   = "db"
# }

# resource "aws_api_gateway_method" "db" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.db.id
#   http_method   = "POST"
#   authorization = "NONE"

#   request_parameters = {
#     "method.request.header.Content-Type"                 = true
#     "method.request.header.Access-Control-Allow-Headers" = true
#   }

# }

# resource "aws_api_gateway_integration" "db" {
#   rest_api_id             = aws_api_gateway_rest_api.main.id
#   resource_id             = aws_api_gateway_resource.db.id
#   http_method             = aws_api_gateway_method.db.http_method
#   integration_http_method = "POST"
#   type                    = "AWS"

#   uri = aws_lambda_function.update_score_lambda.invoke_arn
# }

# resource "aws_api_gateway_method_response" "db" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.db.id
#   http_method = aws_api_gateway_method.db.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Content-Type"                 = true
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = false
#   }
# }

# resource "aws_api_gateway_integration_response" "db" {
#   depends_on  = [aws_api_gateway_integration.db]
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.db.id
#   http_method = aws_api_gateway_method.db.http_method
#   status_code = aws_api_gateway_method_response.db.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }
# }

# // OPTIONS method for CORS preflight
# resource "aws_api_gateway_method" "db_options" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.db.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"

# }

# resource "aws_api_gateway_integration" "db_options" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.db.id
#   http_method = aws_api_gateway_method.db_options.http_method
#   type        = "MOCK"
#   request_templates = {
#     "application/json" = "{\"statusCode\": 200}"
#   }
# }

# resource "aws_api_gateway_method_response" "db_options" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.db.id
#   http_method = aws_api_gateway_method.db_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = false
#     "method.response.header.Access-Control-Allow-Methods" = false
#     "method.response.header.Access-Control-Allow-Origin"  = false
#   }
# }

# resource "aws_api_gateway_integration_response" "db_options" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.db.id
#   http_method = aws_api_gateway_method.db_options.http_method
#   status_code = aws_api_gateway_method_response.db_options.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
#     "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST, PUT, GET'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }

#   depends_on = [
#     aws_api_gateway_method.db_options,
#     aws_api_gateway_integration.db_options,
#   ]
# }

# resource "aws_api_gateway_deployment" "db" {
#   depends_on = [
#     aws_api_gateway_integration.db,
#     aws_api_gateway_integration.db_options,
#   ]
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   stage_name  = "v1"
# }
