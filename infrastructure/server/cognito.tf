resource "aws_cognito_user_pool" "main" {
  name = "${local.prefix}-user-pool"
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "${local.prefix}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${local.prefix}-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.main.id
    provider_name = aws_cognito_user_pool.main.endpoint
  }
}
