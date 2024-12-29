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

  project_name            = var.project_name
  environment            = var.environment
  
  order_queue_arn        = module.messaging.order_queue_arn
  order_queue_url        = module.messaging.order_queue_url
  notification_queue_arn = module.messaging.notification_queue_arn
  notification_queue_url = module.messaging.notification_queue_url
  
  order_dlq_arn         = module.messaging.order_dlq_arn
  order_dlq_url         = module.messaging.order_dlq_url
  notification_dlq_arn  = module.messaging.notification_dlq_arn
  notification_dlq_url  = module.messaging.notification_dlq_url
}