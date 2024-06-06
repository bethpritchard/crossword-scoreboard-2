resource "aws_dynamodb_table" "scores" {
  name         = "${local.prefix}-scores-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"
  attribute {
    name = "name"
    type = "S"
  }

}

resource "aws_dynamodb_table" "websockets" {
  name         = "${local.prefix}-websockets-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connectionId"
  attribute {
    name = "connectionId"
    type = "S"
  }
}
