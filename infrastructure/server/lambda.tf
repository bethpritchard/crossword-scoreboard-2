module "get_score_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-get-score-lambda"
  lambda_source_path    = "${local.lambda_source_path}/get-score"
  api_gateway_arn       = aws_api_gateway_rest_api.main.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.get_score_lambda_policy.arn
  env_vars = {
    DB_TABLE_NAME = aws_dynamodb_table.websockets.name
  }
}

module "update_score_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-update-score-lambda"
  lambda_source_path    = "${local.lambda_source_path}/update-score"
  api_gateway_arn       = aws_api_gateway_rest_api.main.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.update_score_lambda_policy.arn
  env_vars = {
    DB_TABLE_NAME = aws_dynamodb_table.websockets.name
  }
}

module "connect_websockets_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-connect-websockets-lambda"
  lambda_source_path    = "${local.lambda_source_path}/connect-websockets"
  api_gateway_arn       = aws_apigatewayv2_api.websockets.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.connect_websockets_lambda_policy.arn
  env_vars = {
    DB_TABLE_NAME = aws_dynamodb_table.websockets.name
  }
}

module "disconnect_websockets_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-disconnect-websockets-lambda"
  lambda_source_path    = "${local.lambda_source_path}/disconnect-websockets"
  api_gateway_arn       = aws_apigatewayv2_api.websockets.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.disconnect_websockets_lambda_policy.arn
  env_vars = {
    DB_TABLE_NAME = aws_dynamodb_table.websockets.name
  }
}

module "stream_scores_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-stream-scores-lambda"
  lambda_source_path    = "${local.lambda_source_path}/stream-scores"
  api_gateway_arn       = aws_apigatewayv2_api.websockets.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.stream_scores_lambda_policy.arn
  env_vars = {
    REGION                = var.region
    SCORE_TABLE_NAME      = aws_dynamodb_table.scores.name
    CONNECTION_TABLE_NAME = aws_dynamodb_table.websockets.name
    WEBSOCKET_API_ID      = aws_apigatewayv2_api.websockets.id
    WEBSOCKET_API_STAGE   = aws_apigatewayv2_stage.websockets.name
  }
}

module "authorizer_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-authorizer-lambda"
  lambda_source_path    = "${local.lambda_source_path}/authorizer"
  api_gateway_arn       = aws_apigatewayv2_api.websockets.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.authorizer_lambda_policy.arn
  # env_vars = {
  #   JWT_SECRET = var.jwt_secret
  # }

}
