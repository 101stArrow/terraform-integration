resource "aws_s3_bucket" "output_bucket" {
  bucket = var.bucket_name
}

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
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
        RepositoryName = var.repo_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = var.plan_name
    action {
      name             = var.plan_name
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["PlanArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.plan_name
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
    name = var.apply_name
    action {
      name            = var.apply_name
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["PlanArtifact"]
      version         = "1"

      configuration = {
        ProjectName = var.apply_name
      }
    }
  }
}