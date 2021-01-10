resource "aws_appsync_resolver" "listUsersByIds" {
  api_id           = var.api_id
  field            = "listUsersByIds"
  type             = "Query"
  data_source      = aws_appsync_datasource.user_datasource.name
  request_template = <<EOF
{
    #set($ids = [])
    #foreach($id in $ctx.arguments.ids)
        #set($added = $ids.add($id))
    #end

    "version" : "2017-02-28",
    "operation" : "Scan",
    "filter" : {
        "expression" : "id IN :ids",
        "expressionValues": {
            ":ids" : $utils.toJson($ctx.arguments.ids)
        }
    }
    #if( $ctx.args.count )
        ,"limit": $ctx.args.count
    #end
    #if( $ctx.args.nextToken )
        ,"nextToken": "$ctx.args.nextToken"
    #end
}
EOF
  response_template = <<EOF
{
    "todos": $utils.toJson($ctx.result.items)
    #if( $ctx.result.nextToken )
        ,"nextToken": "$ctx.result.nextToken"
    #end
}
EOF
}
