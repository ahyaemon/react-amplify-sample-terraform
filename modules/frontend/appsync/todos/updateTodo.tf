resource "aws_appsync_resolver" "updateTodo" {
  api_id           = var.api_id
  field            = "updateTodo"
  type             = "Mutation"
  data_source      = aws_appsync_datasource.todo_datasource.name

  request_template = <<EOF
{
    "version" : "2018-05-29",
    "operation" : "UpdateItem",
    "key" : {
      "id" : $util.dynamodb.toDynamoDBJson($context.arguments.id)
    },
    "update" : {
      "expression" : "SET #title = :title",
      "expressionNames": {
        "#title" : "title"
      },
      "expressionValues" : {
        ":title" : $util.dynamodb.toDynamoDBJson($context.arguments.title)
      }
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
