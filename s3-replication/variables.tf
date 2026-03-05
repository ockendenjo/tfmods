variable "env" {
  type = string
}

variable "permissions_boundary_arn" {
  type = string
}

variable "source_bucket" {
  type = object({
    id  = string
    arn = string
  })
}

variable "target_bucket" {
  type = object({
    id  = string
    arn = string
  })
}

variable "replicate_back" {
  type = bool
}
