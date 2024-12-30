variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "order_queue_arn" {
  description = "ARN of the order queue"
  type        = string
}

variable "order_queue_url" {
  description = "URL of the order queue"
  type        = string
}

variable "notification_queue_arn" {
  description = "ARN of the notification queue"
  type        = string
}

variable "notification_queue_url" {
  description = "URL of the notification queue"
  type        = string
}

variable "orders_table_arn" {
  description = "ARN of the orders DynamoDB table"
  type        = string
}

variable "orders_table_name" {
  description = "Name of the orders DynamoDB table"
  type        = string
}