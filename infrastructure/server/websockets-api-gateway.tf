resource "aws_apigatewayv2_api" "websockets" {
  name                       = "${local.prefix}-websockets"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "connect_websockets_lambda_integration" {
  api_id             = aws_apigatewayv2_api.websockets.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = module.connect_websockets_lambda.invoke_arn
}
resource "aws_apigatewayv2_route" "connect_route" {
  api_id    = aws_apigatewayv2_api.websockets.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect_websockets_lambda_integration.id}"
}

resource "aws_apigatewayv2_integration" "disconnect_websockets_lambda_integration" {
  api_id             = aws_apigatewayv2_api.websockets.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = module.disconnect_websockets_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id    = aws_apigatewayv2_api.websockets.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect_websockets_lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "websockets" {
  depends_on  = [aws_apigatewayv2_route.connect_route, aws_apigatewayv2_route.disconnect_route]
  api_id      = aws_apigatewayv2_api.websockets.id
  name        = "dev"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
  default_route_settings {
    logging_level          = "INFO"
    throttling_burst_limit = 1000
    throttling_rate_limit  = 500
  }
}


resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/apigateway/${local.prefix}-websockets"
}
