variable "alb_trigger" {}
variable "tg_name" {}
variable "lambda_name" {}

variable "cw_trigger" {}
# variable "cw_event_target_enable" {}
# variable "cw_permission_enable" {}
variable "description" {
    default = "this is cloudwatch trigger"
}
variable "event_pattern" {}
# variable "event_rule_is_enabled" {}
variable "name" {}
# variable "name_prefix" {}
variable "schedule_expression" {}

variable "bucket_name" {}
variable "s3_trigger" {}

variable "sqs_trigger" {}
# variable "sqs_is_enabled" {}
variable "event_source_arn" {}
variable "batch_size" {}
variable "batch_window_seconds" {}


variable "sns_trigger" {
  description = "Conditionally enables this module (and all it's ressources)."
  type        = bool
  default     = false
}
variable "endpoint" {
  description = "The endpoint to send data to (ARN of the Lambda function)"
}
variable "topic_arn" {
  description = "The ARN of the SNS topic to subscribe to"
}

