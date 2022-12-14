variable "attachSubnet" {}
variable "attachSG" {}
variable "attachEFS" {}
variable "dockerBuild" {}
variable "s3_enable" {}
variable "s3_bucket" {}
variable "s3_key" {}
variable "file_system_arn" {}
variable "lambda_name" {
  default = null
}

variable "role_arn" {
  default = null
}

variable "vpc_config" {
  description = "value"
  default = {}
}

variable "cw_logs_retention" {
  default = null
}

variable "subnet_id" {
  description = "subnet id"
}

variable "security_group_id" {
  description = "security group id"
}

variable "image_uri" {
  description = "Lambda Image Uri"
}

variable "filename" {
  default = null
}

variable "handler" {
  default = null
}

variable "memory_size" {
  default = null
}

variable "timeout" {
  default = null
}

variable "layers" {
  default = null
}

variable "source_code_hash" {
  default = null
}

variable "environment" {
  description = "value"
  default = {}
}

variable "tags" {
  default = {}
}

variable "runtime" {
  description = "Lambda Function runtime"
}

variable "cw_error_rate_enable" {
  default = false
  type    = bool
}

variable "cw_invocation_enable" {
  default = false
  type    = bool
}

variable "cw_duration_enable" {
  default = false
  type    = bool
}


