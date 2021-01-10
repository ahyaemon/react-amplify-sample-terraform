resource "aws_ssm_parameter" "user_pool_id" {
  name  = "/cognito/USER_POOL_ID"
  type  = "SecureString"
  value = aws_cognito_user_pool.user_pool.id
}

resource "aws_ssm_parameter" "user_pools_web_client_id" {
  name  = "/cognito/USER_POOLS_WEB_CLIENT_ID"
  type  = "SecureString"
  value = aws_cognito_user_pool_client.user_pool_client.id
}

variable "graphql_endpoint" {}
resource "aws_ssm_parameter" "graphql_endpoint" {
  name  = "/cognito/GRAPHQL_ENDPOINT"
  type  = "SecureString"
  value = var.graphql_endpoint
}

resource "aws_ssm_parameter" "authentication_type" {
  name  = "/cognito/AUTHENTICATION_TYPE"
  type  = "SecureString"
  value = "AMAZON_COGNITO_USER_POOLS"
}

resource "aws_ssm_parameter" "oauth_domain" {
  name  = "/cognito/OAUTH_DOMAIN"
  type  = "SecureString"
  value = "${aws_cognito_user_pool_domain.domain.domain}.auth.ap-northeast-1.amazoncognito.com"
}

resource "aws_ssm_parameter" "oauth_redirect_sign_in" {
  name  = "/cognito/OAUTH_REDIRECT_SIGN_IN"
  type  = "SecureString"
  value = var.callback_url
}

resource "aws_ssm_parameter" "oauth_redirect_sign_out" {
  name  = "/cognito/OAUTH_REDIRECT_SIGN_OUT"
  type  = "SecureString"
  value = var.callback_url
}
