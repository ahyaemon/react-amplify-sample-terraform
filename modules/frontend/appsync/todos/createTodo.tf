resource "aws_appsync_resolver" "createTodo" {
  api_id           = var.api_id
  field            = "createTodo"
  type             = "Mutation"
  data_source      = aws_appsync_datasource.todo_datasource.name
  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "PutItem",
    "key" : {
        "id": $util.dynamodb.toDynamoDBJson($util.autoId()),
    },
    "attributeValues" : $util.dynamodb.toMapValuesJson($ctx.args)
}
EOF
  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}
