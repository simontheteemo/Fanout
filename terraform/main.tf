provider "aws" {
  region = var.aws_region
}

module "messaging" {
  source = "./modules/messaging"

  project_name = var.project_name
  environment  = var.environment
}



module "lambda" {
  source = "./modules/lambda"

  project_name = var.project_name
  environment  = var.environment

  order_queue_arn        = module.messaging.order_queue_arn
  order_queue_url        = module.messaging.order_queue_url
  notification_queue_arn = module.messaging.notification_queue_arn
  notification_queue_url = module.messaging.notification_queue_url

  orders_table_arn       = module.database.orders_table_arn
  orders_table_name      = module.database.orders_table_name
}