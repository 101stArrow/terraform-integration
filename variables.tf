variable "system_id" {
  type        = string
  description = "The Name of the Repository"
}

variable "repo_description" {
  type        = string
  description = "The Description of the Repository"
}

variable "build_description" {
  type        = string
  description = "The Description of the Build Project"
}

variable "security_group" {
  type = string
  default = "sg-02aa7d5fabaaa6b14"
}

variable "vis_enabled" {
  type = bool
  default = true
}

variable "vis_bucket" {
  type = string
}