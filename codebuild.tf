data "template_file" "plan_spec" {
  template = file("${path.module}/files/buildspec.plan.yaml.tpl")
  vars = {
    id = "${var.system_id}_repository",
    bucket = aws_s3_bucket.output_bucket.bucket
  }
}

resource "local_file" "plan_spec" {
  content = data.template_file.plan_spec.rendered
  filename = "buildspec.plan.yaml"
}

resource "local_file" "apply_spec" {
  content = file("${path.module}/files/buildspec.apply.yaml")
  filename = "buildspec.apply.yaml"
}

resource "aws_codebuild_project" "plan" {
  name = "${var.system_id}_plan"
  description = var.build_description

  build_timeout = "5"
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.plan.yaml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "franscape-instance"
      stream_name = "${var.system_id}_plan"
    }
  }

  tags = {
    Name     = var.build_description
    Project  = "franscape"
  }
}

resource "aws_codebuild_project" "apply" {
  name = "${var.system_id}_apply"
  description = var.build_description

  build_timeout = "5"
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.apply.yaml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "franscape-instance"
      stream_name = "${var.system_id}_apply"
    }
  }

  tags = {
    Name     = var.build_description
    Project  = "franscape"
  }
}