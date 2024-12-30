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
