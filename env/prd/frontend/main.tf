module "frontend" {
  source = "../../../modules/frontend/"
  graphql_endpoint = module.frontend_appsync.graphql_endpoint
  callback_url = "https://${module.frontend.cloudfront_domain_name}"
  acm_certificate_arn = "arn:aws:acm:us-east-1:580627628632:certificate/6d784aa8-8d1d-475f-b5b8-2ad495ae9124"
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
