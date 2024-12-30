resource "aws_dynamodb_table" "orders" {
  name           = "${var.project_name}-orders-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderId"
  stream_enabled = false

  attribute {
    name = "orderId"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}