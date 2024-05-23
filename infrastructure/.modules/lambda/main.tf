data "archive_file" "src" {
  type        = "zip"
  source_dir  = var.lambda_source_path
  output_path = "temp/artifacts/${var.lambda_name}zip"
}

resource "aws_lambda_function" "main" {
  function_name    = var.lambda_name
  role             = aws_iam_role.assume_role.arn
  handler          = var.handler_name
  runtime          = var.lambda_runtime
  filename         = data.archive_file.src.output_path
  source_code_hash = data.archive_file.src.output_base64sha256
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_arn}/*/*/*"
}
