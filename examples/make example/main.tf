module "iam_role" {
  source                  = "./terraform-aws-lambda-0.0.1/modules/role"
  name                    = local.workspace.role_name
  policy                  = "${jsonencode(var.policy)}"
}

resource "aws_s3_bucket" "example" {
  bucket = "mytestbucket0000001"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_sns_topic" "test" {
  name = "test"
}

resource "aws_sns_topic_subscription" "test" {
  topic_arn = aws_sns_topic.test.arn
  protocol  = "email"
  endpoint  = "test@test.com"
}

module "lambda_function" {
  source                         = "./terraform-aws-lambda-0.0.1/modules/lambda_functions"
  attachSubnet                   = true
  attachSG                       = true
  attachEFS                      = false
  dockerBuild                    = false
  s3_enable                      = false
  lambda_name                    = "${local.workspace.lambda_name}"
  role_arn                       = "${module.iam_role.role_arn}"
  filename                       = "${local.workspace.lambda_name}.zip"
  s3_bucket                      = local.workspace.s3_bucket != "" ? local.workspace.s3_bucket : aws_s3_bucket.example.id
  s3_key                         = local.workspace.s3_key
  security_group_id              = local.workspace.security_group_id
  subnet_id                      = local.workspace.subnet_id
  handler                        = local.workspace.handler
  runtime                        = local.workspace.runtime
  cw_logs_retention              = local.workspace.cw_logs_retention
  image_uri                      = local.workspace.image_uri
  file_system_arn                = local.workspace.file_system_uri
}

module "triggers" {
  source                              = "./terraform-aws-lambda-0.0.1/modules/lambda_triggers"
  lambda_name                         = "${var.lambda_name}"
  s3_trigger                          = false
  bucket_name                         = local.workspace.s3_bucket != "" ? local.workspace.s3_bucket : aws_s3_bucket.example.id
  alb_trigger                         = false
  tg_name                             = local.workspace.s3_bucket != "" ? local.workspace.s3_bucket : aws_s3_bucket.example.id
  sns_trigger                         = true
  topic_arn                           = local.workspace.sns_topic_arn != "" ? local.workspace.sns_topic_arn : aws_sns_topic.test.arn
  endpoint                            = local.workspace.aws_sns_topic_subscription != "" ? local.workspace.aws_sns_topic_subscription : aws_sns_topic_subscription.test.endpoint

  sqs_trigger                         = false
  event_source_arn                    = local.workspace.sqs_event_source_arn
  batch_size                          = 10
  batch_window_seconds                = 10

  cw_trigger                          = false
  event_pattern                       = "${jsonencode(var.event_pattern)}"
  name                                = "test"
  schedule_expression                 = "rate(1 day), cron(0 17 ? * MON-FRI *)"
} 

module "layers" {
  source                              = "./terraform-aws-lambda-0.0.1/modules/lambda_layer/"
  layer_name                          = "test-layer"
  source_path                         = "."

  nodejs_layer_enable                 = false
  nodejs_build_runtime_version        = "nodejs14.x"
  nodejs_compatible_runtimes          = ["nodejs14.x"]

  python_layer_enable                 = false
  python_build_runtime_version        = "python3.8"
  python_compatible_runtimes          = ["python3.8"]
}

module "cw-alarms" {
  source                              = "./terraform-aws-lambda-0.0.1/modules/cw-alarm"
  lambda_name                         = "${var.lambda_name}"
  sns_arn                             = local.workspace.sns_topic_arn != "" ? local.workspace.sns_topic_arn : aws_sns_topic.test.arn

  cw_error_rate_enable                = true
  err_rate_period                     = 300
  err_rate_threshold                  = 1
  err_rate_statistic                  = "Maximum"
  err_rate_evaluation_period          = "1"
  
  cw_invocation_rate_enable           = false
  invocation_rate_period              = 300
  invocation_rate_threshold           = 100
  invocation_rate_statistic           = "Maximum"
  invocation_rate_evaluation_period   = "1"
  
  cw_duration_enable                  = false
  duration_period                     = 300
  duration_threshold                  = 90000
  duration_statistic                  = "Maximum"
  duration_evaluation_period          = "1"
    
}
