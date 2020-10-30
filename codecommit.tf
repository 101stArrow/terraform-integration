resource "aws_codecommit_repository" "repository" {
  repository_name = "${var.system_id}_repository"
  description     = var.repo_description
}