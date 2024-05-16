
resource "aws_iam_role" "update_score_lambda_role" {
  name = "update-score-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_policy" "update_score_lambda_policy" {
  name        = "update-score-lambda-policy"
  description = "Policy for update score lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "update_score_lambda_policy_attachment" {
  role       = aws_iam_role.update_score_lambda_role.name
  policy_arn = aws_iam_policy.update_score_lambda_policy.arn
}

data "archive_file" "update_score_lambda" {
  type        = "zip"
  source_dir  = "${local.lambda_source_path}/update-score"
  output_path = "temp/artifacts/update-score-lambda.zip"
}

resource "aws_lambda_function" "update_score_lambda" {
  function_name    = "update-score-lambda"
  filename         = data.archive_file.update_score_lambda.output_path
  source_code_hash = data.archive_file.update_score_lambda.output_base64sha256
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.update_score_lambda_role.arn
}

resource "aws_lambda_permission" "update_score_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_score_lambda.arn
  principal     = "apigateway.amazonaws.com"
}
