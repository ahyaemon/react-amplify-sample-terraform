resource "aws_dynamodb_table" "users_table" {
  name           = "Users"
  hash_key       = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_appsync_datasource" "user_datasource" {
  api_id           = var.api_id
  name             = "user_datasource"
  service_role_arn = aws_iam_role.appsync_arn.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.users_table.name
  }
}
