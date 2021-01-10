resource "aws_appsync_resolver" "updateUser" {
  api_id           = var.api_id
  field            = "updateUser"
  type             = "Mutation"
  data_source      = aws_appsync_datasource.user_datasource.name

  request_template = <<EOF
{
    "version" : "2018-05-29",
    "operation" : "UpdateItem",
    "key" : {
      "id" : $util.dynamodb.toDynamoDBJson($context.arguments.id)
    },
    "update" : {
      "expression" : "SET #age = :age, #comment = :comment",
      "expressionNames": {
        "#age" : "age",
        "#comment" : "comment",
      },
      "expressionValues" : {
        ":age" : $util.dynamodb.toDynamoDBJson($context.arguments.age),
        ":comment" : $util.dynamodb.toDynamoDBJson($context.arguments.comment),
      }
    },
    "condition" : {
        "expression"       : "#id = :expectedOwner",
        "expressionNames"  : {
          "#id" : "id"
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
