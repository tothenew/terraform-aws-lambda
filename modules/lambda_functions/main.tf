####################### Lambda with VPC ######################################

resource "aws_lambda_function" "lambda_with_vpc" {
  
  count                   = var.dockerBuild ? 0 : ( var.attachSG ? ( var.attachEFS ? 0 : 1 ) : 0 )
  filename                = "${var.lambda_name}.zip"
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  handler                 = "index.test"
  runtime                 = "${var.runtime}"

  vpc_config {
    subnet_ids         = ["${var.subnet_id}"]
    security_group_ids = ["${var.security_group_id}"]
  }

}



############################# Lambda without VPC #############################################

resource "aws_lambda_function" "lambda_without_vpc" {

  count                   = var.dockerBuild ? 0 : ( var.attachSubnet ? 0 : ( var.s3_enable ? 0 : 1 ))
  filename                = "${var.lambda_name}.zip"
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  handler                 = "index.test"
  runtime                 = "${var.runtime}"
}



################################ Lambda with docker without VPC #################################

resource "aws_lambda_function" "lambda_with_docker_without_vpc" {

  count                   = var.dockerBuild ? ( var.attachSubnet ? 0 : 1 ) : 0
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  image_uri               = "${var.image_uri}"
  package_type            = "Image"  

}



############################## Lambda with docker and VPC ##################################

resource "aws_lambda_function" "lambda_with_docker_vpc" {
  count                   = var.dockerBuild ? ( var.attachSubnet ? 1 : 0 ) : 0
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  image_uri               = "${var.image_uri}"
  package_type            = "Image"
  
  vpc_config {
    subnet_ids         = ["${var.subnet_id}"]
    security_group_ids = ["${var.security_group_id}"]
  }
}



###################### Lambda with S3 without VPC #####################

resource "aws_lambda_function" "lambda_with_s3_without_vpc" {

  count                   = var.s3_enable ? ( var.attachSubnet ? 0 : 1 ) : 0
  s3_bucket               = "${var.s3_bucket}"
  s3_key                  = "${var.s3_key}" # its mean its depended on upload key
  #source_code_hash        = "${data.archive_file.source.output_bash64sha256}"
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  handler                 = "index.test"
  runtime                 = "${var.runtime}"
}




####################### Lambda with VPC and S3 ######################################

resource "aws_lambda_function" "lambda_with_vpc_s3" {
  
  count                   = var.s3_enable ? ( var.attachSubnet ? 1 : 0 ) : 0
  filename                = "${var.lambda_name}.zip"
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  handler                 = "index.test"
  runtime                 = "${var.runtime}"

  vpc_config {
    subnet_ids         = ["${var.subnet_id}"]
    security_group_ids = ["${var.security_group_id}"]
  }

}




######################### Lambda with EFS and VPC ###############################

resource "aws_lambda_function" "lambda_with_EFS_VPC" {

  count                   = var.attachEFS ? ( ( var.attachSubnet ? ( var.attachSG ? 1 : 0 ) : 0 ) ) : 0
  filename                = "${var.lambda_name}.zip"
  function_name           = "${var.lambda_name}"
  role                    = "${var.role_arn}"
  handler                 = "index.test"
  runtime                 = "${var.runtime}"

  file_system_config {
    # EFS file system access point ARN
    arn = "${var.file_system_arn}"

    # Local mount path inside the lambda function. Must start with '/mnt/'.
    local_mount_path = "/mnt/efs"
  }

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = ["${var.subnet_id}"]
    security_group_ids = ["${var.security_group_id}"]
  }

}



############################## Lambda log group ###################################

resource "aws_cloudwatch_log_group" "lambda_cw_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = var.cw_logs_retention
  depends_on = [
    var.lambda_name
  ]
}


