output "sns_topic_arn" {
  value = aws_sns_topic.main.arn
}

output "order_queue_url" {
  value = aws_sqs_queue.orders.id
}

output "order_queue_arn" {
  value = aws_sqs_queue.orders.arn
}

output "notification_queue_url" {
  value = aws_sqs_queue.notifications.id
}

output "notification_queue_arn" {
  value = aws_sqs_queue.notifications.arn
}

output "order_dlq_url" {
  value = aws_sqs_queue.orders_dlq.id
}

output "order_dlq_arn" {
  value = aws_sqs_queue.orders_dlq.arn
}

output "notification_dlq_url" {
  value = aws_sqs_queue.notifications_dlq.id
}

output "notification_dlq_arn" {
  value = aws_sqs_queue.notifications_dlq.arn
}