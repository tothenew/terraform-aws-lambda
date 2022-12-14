variable "lambda_name" {
  default = null
}

variable "timeout" {
  default = null
}

variable "err_rate_period" {
    default = 300
}

variable "invocation_rate_period" {
    default = 300
}

variable "duration_period" {
    default = 300
}

variable "err_rate_threshold" {
    default = 1
}

variable "invocation_rate_threshold" {
    default = 100
}

variable "duration_threshold" {
    default = 90000
}

variable "err_rate_evaluation_period" {
    default = "1"
}

variable "invocation_rate_evaluation_period" {
    default = "1"
}

variable "duration_evaluation_period" {
    default = "1"
}

variable "err_rate_statistic" {
    default = "Maximum"
}

variable "invocation_rate_statistic" {
    default = "Maximum"
}

variable "duration_statistic" {
    default = "Maximum"
}

variable "sns_arn" {
  description = "SNS topic ARN for sending CloudWatch alarms notifications"
}

variable "cw_error_rate_enable" {
  default = false
  type    = bool
}

variable "cw_invocation_rate_enable" {
  default = false
  type    = bool
}

variable "cw_duration_enable" {
  default = false
  type    = bool
}
