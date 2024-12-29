output "order_processor_function_name" {
  value = aws_lambda_function.order_processor.function_name
}

output "notification_processor_function_name" {
  value = aws_lambda_function.notification_processor.function_name
}

output "order_dlq_processor_function_name" {
  value = aws_lambda_function.order_dlq_processor.function_name
}

output "notification_dlq_processor_function_name" {
  value = aws_lambda_function.notification_dlq_processor.function_name
}