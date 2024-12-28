# Lambda roles and policies
resource "aws_iam_role" "lambda_role" {
  name = "lambda_sqs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "lambda_sqs" {
  name = "lambda_sqs_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.orders.arn,
          aws_sqs_queue.notifications.arn
        ]
      }
    ]
  })
}

# Order Processing Lambda
resource "aws_lambda_function" "order_processor" {
  filename         = "order-processor.zip"
  function_name    = "order-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.orders.id
    }
  }
}

# Notification Processing Lambda
resource "aws_lambda_function" "notification_processor" {
  filename         = "notification-processor.zip"
  function_name    = "notification-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.notifications.id
    }
  }
}

# Lambda Event Source Mappings
resource "aws_lambda_event_source_mapping" "order_queue_mapping" {
  event_source_arn = aws_sqs_queue.orders.arn
  function_name    = aws_lambda_function.order_processor.arn
  batch_size       = 1
}

resource "aws_lambda_event_source_mapping" "notification_queue_mapping" {
  event_source_arn = aws_sqs_queue.notifications.arn
  function_name    = aws_lambda_function.notification_processor.arn
  batch_size       = 1
}