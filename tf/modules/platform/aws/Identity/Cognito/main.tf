

resource "aws_cognito_user_pool" "user_pool" {
  name                            = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                            = var.pool_client_name
  user_pool_id                    = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_domain" "main" {
  domain                          = var.dns_domain_name
  user_pool_id                    = aws_cognito_user_pool.user_pool.id
}