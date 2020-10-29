resource "aws_codecommit_repository" "instance" {
  repository_name = var.repo_name
  description     = var.repo_description
}

data "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket
}