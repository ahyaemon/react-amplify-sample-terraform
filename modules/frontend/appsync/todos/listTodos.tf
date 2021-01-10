resource "aws_appsync_resolver" "listTodos" {
  api_id           = var.api_id
  field            = "listTodos"
  type             = "Query"
  data_source      = aws_appsync_datasource.todo_datasource.name
  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "Scan"
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
    #set($myResults = [])
    #foreach($item in $ctx.result.items)
        #if($item.owner == $ctx.identity.username)
            #set($added = $myResults.add($item))
        #end
    #end

    "todos": $utils.toJson($myResults)
    #if( $ctx.result.nextToken )
        ,"nextToken": "$ctx.result.nextToken"
    #end
}
EOF
}
