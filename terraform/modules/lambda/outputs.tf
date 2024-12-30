output "order_processor_function_name" {
  value = aws_lambda_function.order_processor.function_name
}

output "notification_processor_function_name" {
  value = aws_lambda_function.notification_processor.function_name
}