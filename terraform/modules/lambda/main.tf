# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role-${var.environment}"

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

# CloudWatch Logs policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# SQS policy for Lambda
resource "aws_iam_role_policy" "lambda_sqs" {
  name = "${var.project_name}-lambda-sqs-policy-${var.environment}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage"
        ]
        Resource = [
          var.order_queue_arn,
          var.notification_queue_arn
        ]
      }
    ]
  })
}

# Lambda Functions
resource "aws_lambda_function" "order_processor" {
  filename      = "${path.module}/order-processor.zip"
  function_name = "${var.project_name}-order-processor-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 30
  memory_size   = 128

  source_code_hash = filebase64sha256("${path.module}/order-processor.zip")

  environment {
    variables = {
      QUEUE_URL      = var.order_queue_url
      ENV            = var.environment
      DYNAMODB_TABLE = var.orders_table_name
    }
  }
}

resource "aws_lambda_function" "notification_processor" {
  filename      = "${path.module}/notification-processor.zip"
  function_name = "${var.project_name}-notification-processor-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 30
  memory_size   = 128

  source_code_hash = filebase64sha256("${path.module}/notification-processor.zip")
  
  environment {
    variables = {
      QUEUE_URL = var.notification_queue_url
      ENV       = var.environment
    }
  }
}

# Event Source Mappings
resource "aws_lambda_event_source_mapping" "order_queue_mapping" {
  event_source_arn = var.order_queue_arn
  function_name    = aws_lambda_function.order_processor.arn
  batch_size       = 1
}

resource "aws_lambda_event_source_mapping" "notification_queue_mapping" {
  event_source_arn = var.notification_queue_arn
  function_name    = aws_lambda_function.notification_processor.arn
  batch_size       = 1
}

resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "${var.project_name}-lambda-dynamodb-policy-${var.environment}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ]
        Resource = [
          var.orders_table_arn
        ]
      }
    ]
  })
}