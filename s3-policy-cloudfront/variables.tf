variable "bucket" {
  type = object({
    arn = string
    id  = string
  })
}

variable "cloudfront_arns" {
  type = list(string)
}
