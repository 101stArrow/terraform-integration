resource "aws_s3_bucket" "output_bucket" {
  bucket = "${var.system_id}_bucket"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.system_id}_pipeline"
  role_arn = aws_iam_role.build.arn

  artifact_store {
    location = aws_s3_bucket.output_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "${var.system_id}_repository"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "${var.system_id}_plan"
    action {
      name             = "${var.system_id}_plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["PlanArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${var.system_id}_plan"
      }
    }
  }

  stage {
    name = "Manual_Approval"
    action {
      name     = "Manual-Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "${var.system_id}_apply"
    action {
      name            = "${var.system_id}_apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["PlanArtifact"]
      version         = "1"

      configuration = {
        ProjectName = "${var.system_id}_apply"
      }
    }
  }
}