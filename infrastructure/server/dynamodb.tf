resource "aws_dynamodb_table" "main" {
  name         = "${local.prefix}-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"
  attribute {
    name = "name"
    type = "S"
  }

}
