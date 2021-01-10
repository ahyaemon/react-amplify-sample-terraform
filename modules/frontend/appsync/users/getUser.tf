resource "aws_appsync_resolver" "getUser" {
  api_id           = var.api_id
  field            = "getUser"
  type             = "Query"
  data_source      = aws_appsync_datasource.user_datasource.name
  request_template = <<EOF
{
    "version": "2017-02-28",
    "operation": "GetItem",
    "key": {
        "id": $util.dynamodb.toDynamoDBJson($ctx.identity.username),
    }
}
EOF
  response_template = <<EOF
#if($ctx.result["id"] == $context.identity.username)
    $util.toJson($ctx.result)
#else
    $utils.unauthorized()
#end
EOF
}
