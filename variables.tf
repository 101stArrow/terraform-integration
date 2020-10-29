variable "repo_name" {
  type        = string
  description = "The Name of the Repository"
}

variable "repo_description" {
  type        = string
  description = "The Description of the Repository"
}

variable "build_name" {
  type        = string
  description = "The Name of the Build Project"
}

variable "build_description" {
  type        = string
  description = "The Description of the Build Project"
}

variable "output_bucket" {
  type        = string
  description = "The Name of the Output Bucket"
}

variable "output_key" {
  type        = string
  description = "The Key of the Output Bucket"
}