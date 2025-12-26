variable "role_id" {
  type = string
}

variable "bucket_arn" {
  type = string
}

variable "allow_write" {
  type    = bool
  default = false
}

variable "allow_delete" {
  type    = bool
  default = false
}
