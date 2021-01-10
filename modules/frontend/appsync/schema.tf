variable "user_pool_id" {}

resource "aws_iam_role" "graphql_log_role" {
  name = "example"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "appsync.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_appsync_graphql_api" "graphql_api" {
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = "graphql_api"
  schema              = file("${path.module}/schema.graphql")

  user_pool_config {
    aws_region     = "ap-northeast-1"
    default_action = "ALLOW"
    user_pool_id   = var.user_pool_id
  }

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.graphql_log_role.arn
    field_log_level = "ERROR"
  }
}

output "api_id" {
  value = aws_appsync_graphql_api.graphql_api.id
}

output "graphql_endpoint" {
  value = aws_appsync_graphql_api.graphql_api.uris["GRAPHQL"]
}

