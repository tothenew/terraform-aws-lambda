variable "policy" {
    default = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                
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
