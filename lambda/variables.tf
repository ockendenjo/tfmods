variable "s3_bucket" {
  type = string
}

variable "project_name" {
  type = string
}

variable "s3_object_key" {
  type = string
}

variable "name" {
  type = string
}

variable "permissions_boundary_arn" {
  type = string
}

variable "environment" {
  description = "Lambda environment variables"
  type        = map(string)
}

variable "aws_env" {
  type = string
}

variable "alarm_topic_arn" {
  type = string
}
