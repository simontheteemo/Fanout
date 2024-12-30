# Fanout

SNS Topic
- Order Queue ──> Order Lambda --> DynamoDB
- Notification Queue ──> Notification Lambda --> SSM


Messaging System
- SNS Topic for publishing messages
- Multiple SQS Queues for message distribution
- Dead Letter Queues (DLQ) for error handling
- AWS Console's redrive feature for message retry

Processing
- Lambda functions for message processing
- DynamoDB for data persistence
- Node.js with external dependencies (aws-sdk, lodash)

Infrastructure as Code
Terraform for AWS resource management
Modular structure:
- messaging module (SNS/SQS)
- database module (DynamoDB)
- lambda module (Functions/IAM)

CI/CD Pipeline
- GitHub Actions for automated deployment
- Proper Lambda packaging with dependencies
- Clean build process in isolated directories
- State management using S3 backend

Highlights
- Modular Terraform structure
- Lambda function packaging with dependencies
- State management in Terraform
- SQS DLQ and redrive patterns
- GitHub Actions deployment workflow

This setup provides a scalable, maintainable foundation for event-driven architectures in AWS.

Test Message for SNS Topic

```
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
```