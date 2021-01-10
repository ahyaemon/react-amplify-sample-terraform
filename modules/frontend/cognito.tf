resource "aws_cognito_user_pool" "user_pool" {
  name = "user_pool"

  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  alias_attributes = ["email"]

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "frontend_application"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls                        = ["http://localhost:3000/", var.callback_url,]
  logout_urls                          = ["http://localhost:3000/", var.callback_url,]

  prevent_user_existence_errors = "LEGACY"
  refresh_token_validity        = 30
  supported_identity_providers  = ["COGNITO", "Google"]

  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  generate_secret     = false
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "ahyaemon-amplify-sample"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

data "aws_secretsmanager_secret" "secret" {
  name = "cognito/google"
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

resource "aws_cognito_identity_provider" "provider" {
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "profile email openid"
    client_id        = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["client_id"]
    client_secret    = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["client_secret"]

    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = true
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email          = "email"
    email_verified = "email_verified"
    name           = "name"
    username       = "sub"
  }
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}
