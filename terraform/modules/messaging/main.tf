# SNS Topic
resource "aws_sns_topic" "main" {
  name = "${var.project_name}-topic-${var.environment}"
}

# Dead Letter Queues
resource "aws_sqs_queue" "orders_dlq" {
  name                      = "${var.project_name}-order-dlq-${var.environment}"
  message_retention_seconds = 1209600  # 14 days
}

resource "aws_sqs_queue" "notifications_dlq" {
  name                      = "${var.project_name}-notification-dlq-${var.environment}"
  message_retention_seconds = 1209600  # 14 days
}

# Main Queues
resource "aws_sqs_queue" "orders" {
  name                      = "${var.project_name}-order-queue-${var.environment}"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400  # 1 day
  receive_wait_time_seconds  = 20     # Long polling
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orders_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "notifications" {
  name                      = "${var.project_name}-notification-queue-${var.environment}"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 20
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notifications_dlq.arn
    maxReceiveCount     = 3
  })
}

# Queue Policies
resource "aws_sqs_queue_policy" "orders" {
  queue_url = aws_sqs_queue.orders.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.orders.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.main.arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "notifications" {
  queue_url = aws_sqs_queue.notifications.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.notifications.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.main.arn
          }
        }
      }
    ]
  })
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "orders" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.orders.arn
}

resource "aws_sns_topic_subscription" "notifications" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notifications.arn
}