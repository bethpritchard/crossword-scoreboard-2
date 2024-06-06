resource "aws_iam_policy" "update_score_lambda_policy" {
  name        = "${local.prefix}-update-score-lambda-policy"
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
        Resource = aws_dynamodb_table.scores.arn
      }
    ]
  })
}


resource "aws_iam_policy" "get_score_lambda_policy" {
  name        = "${local.prefix}-get-score-lambda-policy"
  description = "Policy for update score lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem"
        ],
        Resource = aws_dynamodb_table.scores.arn
      }
    ]
  })
}

resource "aws_iam_policy" "connect_websockets_lambda_policy" {
  name        = "${local.prefix}-connect-websockets-lambda-policy"
  description = "Policy for connect websockets lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem"
        ],
        Resource = aws_dynamodb_table.websockets.arn
      }
    ]
  })
}

resource "aws_iam_policy" "disconnect_websockets_lambda_policy" {
  name        = "${local.prefix}-disconnect-websockets-lambda-policy"
  description = "Policy for disconnect websockets lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:DeleteItem"
        ],
        Resource = aws_dynamodb_table.websockets.arn
      }
    ]
  })
}
