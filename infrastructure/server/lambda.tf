module "get_score_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-get-score-lambda"
  lambda_source_path    = "${local.lambda_source_path}/get-score"
  api_gateway_arn       = aws_api_gateway_rest_api.main.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.get_score_lambda_policy.arn
  table_name            = aws_dynamodb_table.scores.name
}

module "update_score_lambda" {
  source                = "../.modules/lambda"
  lambda_name           = "${local.prefix}-update-score-lambda"
  lambda_source_path    = "${local.lambda_source_path}/update-score"
  api_gateway_arn       = aws_api_gateway_rest_api.main.execution_arn
  lambda_iam_policy_arn = aws_iam_policy.update_score_lambda_policy.arn
  table_name            = aws_dynamodb_table.scores.name
}
