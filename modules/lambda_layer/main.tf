locals {
  build_target_dir  = "/tmp/${var.layer_name}"
  source_dir        = "/tmp/${var.layer_name}"
  output_path       = "/tmp/${var.layer_name}.zip"
  build_command     = "${var.python_build_runtime_version} -m pip install -r ${var.source_path}/requirements.txt -t ${local.build_target_dir}"
}

resource "null_resource" "python" {
  count           = var.python_layer_enable ? 1 : 0
  triggers = {
    package_file  = "${base64sha256(file("${var.source_path}/requirements.txt"))}"
  }

    provisioner "local-exec" {
      command  = local.build_command
  }
  lifecycle {
    ignore_changes = [triggers]
  }
}

data "archive_file" "python_layer" {
  count = var.python_layer_enable ? 1 : 0
  type = "zip"
  source_dir  = local.source_dir
  output_path = local.output_path
  depends_on  = [
    null_resource.python
  ]
}

resource "aws_lambda_layer_version" "python_layer_version" {
  count               = var.python_layer_enable ? 1 : 0
  filename            = data.archive_file.python_layer[count.index].output_path
  layer_name          = var.layer_name
  source_code_hash    = data.archive_file.python_layer[count.index].output_base64sha256
  compatible_runtimes = var.python_compatible_runtimes
  description         = var.description
  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}


resource "null_resource" "nodejs" {
  count    = var.nodejs_layer_enable ? 1 : 0
  triggers = {
    package_file  = "${base64sha256(file("${var.source_path}/package.json"))}"
  }
    provisioner "local-exec" {
      command = <<-EOT
      . ~/.nvm/nvm.sh
      nvm install ${var.nodejs_build_runtime_version}
      nvm use ${var.nodejs_build_runtime_version}
      node --version
      yarn install
      mkdir -p ${local.build_target_dir}
      cp -r node_modules ${local.build_target_dir}
      rm -rf node_modules
      EOT
      working_dir = var.source_path
  }
   lifecycle {
    ignore_changes = [triggers]
  }
}

data "archive_file" "nodejs_layer" {
  count = var.nodejs_layer_enable ? 1 : 0
  type = "zip"
  source_dir  = local.source_dir
  output_path = local.output_path
  depends_on  = [
    null_resource.nodejs
  ]
}

resource "aws_lambda_layer_version" "nodejs_layer_version" {
  count               = var.nodejs_layer_enable ? 1 : 0
  filename            = data.archive_file.nodejs_layer[count.index].output_path
  layer_name          = var.layer_name
  source_code_hash    = data.archive_file.nodejs_layer[count.index].output_base64sha256
  compatible_runtimes = var.nodejs_compatible_runtimes
  description         = var.description
  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

