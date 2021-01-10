resource "aws_appsync_resolver" "deleteTodo" {
  api_id           = var.api_id
  field            = "deleteTodo"
  type             = "Mutation"
  data_source      = aws_appsync_datasource.todo_datasource.name

  request_template = <<EOF
{
    "version" : "2018-05-29",
    "operation" : "DeleteItem",
    "key" : {
      "id" : $util.dynamodb.toDynamoDBJson($context.arguments.id)
    },
    "condition" : {
        "expression"       : "#owner = :expectedOwner",
        "expressionNames"  : {
          "#owner" : "owner"
        },
        "expressionValues" : {
            ":expectedOwner" : { "S" : "$${context.identity.username}" }
        }
    }
}
EOF

  response_template = <<EOF
    $util.toJson($ctx.result)
EOF

}
