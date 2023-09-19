variable "policy" {
  default = {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:Describe*",
          "s3:GetObject",
          "s3:PutObject",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        "Resource": "*"
      }
    ]
  }
}

variable "event_pattern" {
    default = {
            "source": [
                "aws.autoscaling"
            ]
        }
    
}

variable "lambda_name" {
    default = "test"
}
