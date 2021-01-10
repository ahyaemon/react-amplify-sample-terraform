module "frontend" {
  source = "../../../modules/frontend/"
  graphql_endpoint = module.frontend_appsync.graphql_endpoint
  callback_url = "https://${module.frontend.cloudfront_domain_name}"
}

module "frontend_appsync" {
  source = "../../../modules/frontend/appsync/"

  user_pool_id = module.frontend.user_pool_id
}

module "frontend_appsync_todos" {
  source = "../../../modules/frontend/appsync/todos"

  api_id = module.frontend_appsync.api_id
}

module "frontend_appsync_users" {
  source = "../../../modules/frontend/appsync/users"

  api_id = module.frontend_appsync.api_id
}
