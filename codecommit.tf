resource "aws_codecommit_repository" "instance" {
  repository_name = var.repo_name
  description     = "The ${var.brand_name} State Repository"
}