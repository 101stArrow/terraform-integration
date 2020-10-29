resource "aws_codebuild_project" "plan" {
  name = var.plan_name
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
      stream_name = var.plan_name
    }
  }

  tags = {
    Name     = var.build_description
    Project  = "franscape"
  }
}

resource "aws_codebuild_project" "apply" {
  name = var.apply_name
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
      stream_name = var.apply_name
    }
  }

  tags = {
    Name     = var.build_description
    Project  = "franscape"
  }
}