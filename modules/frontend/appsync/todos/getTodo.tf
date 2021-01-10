resource "aws_appsync_resolver" "getTodo" {
  api_id           = var.api_id
  field            = "getTodo"
  type             = "Query"
  data_source      = aws_appsync_datasource.todo_datasource.name
  request_template = <<EOF
{
    "version": "2017-02-28",
    "operation": "GetItem",
    "key": {
        "id": $util.dynamodb.toDynamoDBJson($ctx.args.id),
    }
}
EOF
  response_template = <<EOF
#if($ctx.result["owner"] == $context.identity.username)
    $util.toJson($ctx.result)
#else
    $utils.unauthorized()
#end
EOF
}
