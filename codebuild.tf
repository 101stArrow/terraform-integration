resource "aws_codebuild_project" "plan" {
  name = var.build_name
  description = var.build_description

  build_timeout = "5"
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "S3"
    location = var.output_bucket
    name = var.output_key
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "franscape-instance-plan"
      stream_name = var.build_name
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.repository.clone_url_http
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "refs/heads/master"

  tags = {
    Name     = var.build_description
    Project  = "franscape"
  }
}