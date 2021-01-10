resource "aws_appsync_resolver" "allTodos" {
  api_id           = var.api_id
  field            = "allTodos"
  type             = "Query"
  data_source      = aws_appsync_datasource.todo_datasource.name
  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "Scan"
}
EOF
  response_template = <<EOF
{
    $util.toJson($ctx.result.items)
}
EOF
}
