# Terraform AWS Lambda Module Suite

## Introduction

This Terraform configuration deploys AWS Lambda functions along with necessary IAM roles, event triggers, Lambda layers, and CloudWatch alarms using modular components. It simplifies managing serverless infrastructure on AWS.

---

## Explanation of Module

This setup splits Lambda deployment into focused modules:

- IAM Role creation with attached policies.
- Lambda function deployment supporting zip file or container image.
- Lambda Layers management.
- CloudWatch alarms for monitoring Lambda functions.

Modules can be used independently or combined as needed.


---

## Resources Created and Managed

- IAM roles for Lambda execution
- AWS Lambda functions with runtime, handler, and deployment config
- Event source triggers (S3, SNS, SQS, ALB, CloudWatch)
- Lambda Layers for shared dependencies
- CloudWatch alarms for Lambda metrics

---

## Example Usage

```hcl
module "iam_role" {
  source = "./modules/role"
  name   = "lambda-basic-role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "logs:*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

module "lambda_function" {
  source      = "./modules/lambda_functions"
  lambda_name = "basic_lambda"
  role_arn    = module.iam_role.role_arn
  filename    = "basic_lambda.zip"
  handler     = "index.handler"
  runtime     = "python3.8"
}
