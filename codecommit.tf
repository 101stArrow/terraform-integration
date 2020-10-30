resource "aws_codecommit_repository" "repository" {
  repository_name = replace("${var.system_id}_repository", "_", "-")
  description     = var.repo_description
}