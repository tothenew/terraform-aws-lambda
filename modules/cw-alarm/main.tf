resource "aws_cloudwatch_metric_alarm" "error_rate" {
  count               = var.cw_error_rate_enable ? 1 : 0
  alarm_name          = "${var.lambda_name}-error-rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.err_rate_evaluation_period
  metric_name         = "Errors"
  period              = var.err_rate_period
  statistic           = var.err_rate_statistic
  threshold           = var.err_rate_threshold
  unit                = "Count"
  namespace           = "AWS/Lambda"
  alarm_description  = "Lambdas with errors"
  alarm_actions      = ["${var.sns_arn}"]
  ok_actions         = ["${var.sns_arn}"]
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "invocation_rate" {
  count               = var.cw_invocation_rate_enable ? 1 : 0
  alarm_name          = "${var.lambda_name}-invocation-rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.invocation_rate_evaluation_period
  metric_name         = "Invocations"
  period              = var.invocation_rate_period
  statistic           = var.invocation_rate_statistic
  threshold           = var.invocation_rate_threshold
  unit                = "Count"
  namespace           = "AWS/Lambda"
  alarm_description  = "Lambdas with errors"
  alarm_actions      = ["${var.sns_arn}"]
  ok_actions         = ["${var.sns_arn}"]
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "Duration" {
  count               = var.cw_duration_enable ? 1 : 0
  alarm_name          = "${var.lambda_name}-duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.err_rate_evaluation_period
  metric_name         = "Duration"
  period              = var.duration_period
  statistic           = var.duration_statistic
  threshold           = var.duration_threshold
  unit                = "Count"
  namespace           = "AWS/Lambda"
  alarm_description  = "Lambdas with errors"
  alarm_actions      = ["${var.sns_arn}"]
  ok_actions         = ["${var.sns_arn}"]
  treat_missing_data = "notBreaching"
} 