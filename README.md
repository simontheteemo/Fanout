# Fanout

SNS Topic
- Order Queue ──> Order Lambda
- Notification Queue ──> Notification Lambda


Test Message for SNS Topic
{
  "orderId": "TEST-123",
  "customerName": "John Doe",
  "items": [
    {
      "productId": "PROD-001",
      "quantity": 2,
      "price": 29.99
    }
  ],
  "totalAmount": 59.98
}