variable "role_id" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "allow_decrypt" {
  type    = bool
  default = true
}

variable "allow_encrypt" {
  type    = bool
  default = false
}
