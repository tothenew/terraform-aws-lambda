module "iam_role" {
    source                  = "./modules/role"
    name                    = "lambda-role"
    policy                  = "${jsonencode(var.policy)}"
}

module "lambda_function" {
  
    source                         = "./modules/lambda_functions"
    attachSubnet                   = false
    attachSG                       = false
    attachEFS                      = false
    dockerBuild                    = false
    s3_enable                      = false

    lambda_name                    = "${var.lambda_name}"
    role_arn                       = "${module.iam_role.role_arn}"
    filename                       = "${var.lambda_name}.zip"
    file_system_arn                = "arn:aws:efs:us-east-1:999999999999:test"
    s3_bucket                      = "s3_lambda_bucket"
    s3_key                         = "lambda/lambda_function.zip"
    image_uri                      = "999999999.dkr.ecr.us-east-1.amazonaws.com/lambda:function"
    security_group_id              = "sg-99959595"
    subnet_id                      = "subnet-0000000"
    handler                        = "index.test"
    runtime                        = "python3.8"
    cw_logs_retention              = 7

}

module "triggers" {
    source                              = "./modules/lambda_triggers"
    lambda_name                         = "${var.lambda_name}"

    s3_trigger                          = false
    bucket_name                         = "test"

    alb_trigger                         = false
    tg_name                             = "test"

    sns_trigger                         = false
    topic_arn                           = "arn:aws:sns:us-east-1:999999999999:test"
    endpoint                            = "abc"

    sqs_trigger                         = false
    event_source_arn                    = "arn:aws:sqs:us-east-1:999999999999:test"
    batch_size                          = 10
    batch_window_seconds                = 10

    cw_trigger                          = false
    event_pattern                       = "${jsonencode(var.event_pattern)}"
    name                                = "test"
    schedule_expression                 = "rate(1 day), cron(0 17 ? * MON-FRI *)"
} 

module "layers" {
    source                              = "./modules/lambda_layer/"
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
    source                              = "./modules/cw-alarm"
    lambda_name                         = "${var.lambda_name}"
    sns_arn                             = "arn:aws:sns:us-east-1:999999999999:test"

    cw_error_rate_enable                = false
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
