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
        Resource = aws_dynamodb_table.main.arn
      }
    ]
  })
}


resource "aws_iam_policy" "get_score_lambda_policy" {
  name        = "get-score-lambda-policy"
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
        Resource = aws_dynamodb_table.main.arn
      }
    ]
  })
}
