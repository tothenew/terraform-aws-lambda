data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  id      = data.aws_caller_identity.current.account_id
  region  = data.aws_region.current.name
  source_arn = "arn:aws:elasticloadbalancing:${local.region}:${local.id}:targetgroup/${var.tg_name}"
}

######################## ALB trigger ########################

resource "aws_lambda_permission" "allow_alb" {
  count         = var.alb_trigger ? 1 : 0
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = local.source_arn
}

############################# S3 trigger ###############################

resource "aws_lambda_permission" "allow_bucket" {
  count         = var.s3_trigger ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

####################### SQS trigger ###############################

resource "aws_lambda_event_source_mapping" "sqs" {
  count            = var.sqs_trigger ? 1 : 0
  batch_size       = var.batch_size
#   enabled          = var.sqs_is_enabled
  event_source_arn = var.event_source_arn
  function_name    = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
  maximum_batching_window_in_seconds = var.batch_window_seconds
}


################## SNS trigger ####################################

resource "aws_lambda_permission" "sns" {
  count         = var.sns_trigger ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
  principal     = "sns.amazonaws.com"
  statement_id  = "AllowSubscriptionToSNS"
  source_arn    = var.topic_arn
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = var.sns_trigger ? 1 : 0
  endpoint  = var.endpoint
  protocol  = "lambda"
  topic_arn = var.topic_arn
}




############################# Cloudwatch trigger ###############################

resource "aws_lambda_permission" "cloudwatch" {
  count         = var.cw_trigger ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[count.index].arn
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = var.cw_trigger ? 1 : 0
  description         = var.description
  event_pattern       = var.event_pattern
#   is_enabled          = var.event_rule_is_enabled
  name                = var.name
  # name_prefix         = var.name_prefix
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.cw_trigger ? 1 : 0
  rule  = aws_cloudwatch_event_rule.lambda[count.index].name
  arn   = "arn:aws:lambda:${local.region}:${local.id}:function:${var.lambda_name}"
}


