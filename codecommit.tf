resource "aws_codecommit_repository" "repository" {
  repository_name = var.repo_name
  description     = var.repo_description
}