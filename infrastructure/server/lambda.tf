module "update_score_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "update-score-lambda"
  description   = "Perist score to DynamoDB"
  runtime       = "python3.12"
  handler       = "main.lambda_handler"
  source_path   = "${local.lambda_source_path}/update-score"
  artifacts_dir = "${local.lambda_source_path}/update-score/dist"
}

